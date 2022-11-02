/*
 * Zlib Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>

#include <yonk/input-zlib.h>

#include <zlib.h>

static void zlib_input_free (struct input *o);
static int  zlib_input_read (struct input *o, void *buf, unsigned count);

static const struct input_type zlib_input_type = {
	.free	= zlib_input_free,
	.read	= zlib_input_read,
};

struct zlib_input {
	struct input core;

	z_stream s;
	unsigned char buf[BUFSIZ];
};

int input_push_zlib (struct input **input)
{
	struct zlib_input *o;

	if ((o = malloc (sizeof (*o))) == NULL)
		return 0;

	o->core.type = &zlib_input_type;
	o->core.next = *input;

	o->s.next_in  = o->buf;
	o->s.avail_in = 0;

	o->s.zalloc = NULL;
	o->s.zfree  = NULL;
	o->s.opaque = NULL;

	switch (inflateInit (&o->s)) {
	case Z_OK:		*input = &o->core; return 1;
	case Z_MEM_ERROR:	errno = ENOMEM; break;
	default:		errno = EINVAL; break;
	}

	free (o);
	return 0;
}

static void zlib_input_free (struct input *O)
{
	struct zlib_input *o = (void *) O;

	inflateEnd (&o->s);
	free (o);
}

static int zlib_input_read (struct input *O, void *buf, unsigned count)
{
	struct zlib_input *o = (void *) O;
	int ret;

	o->s.next_out  = buf;
	o->s.avail_out = count;

	do {
		if (o->s.avail_in == 0) {
			ret = input_read (o->core.next, o->buf, sizeof (o->buf));
			if (ret < 0)
				return -1;

			o->s.next_in  = o->buf;
			o->s.avail_in = ret;
		}

		ret = inflate (&o->s, Z_NO_FLUSH);
	}
	while (ret == Z_OK && o->s.avail_out > 0);

	switch (ret) {
	case Z_OK:
	case Z_BUF_ERROR:
	case Z_STREAM_END:	return count - o->s.avail_out;
	case Z_MEM_ERROR:	errno = ENOMEM; break;
	default:		errno = EILSEQ; break;
	}

	return -1;
}
