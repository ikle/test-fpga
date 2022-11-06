/*
 * Bzip2 Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>

#include <yonk/input/bz2.h>

#include <bzlib.h>

static void      bz2_input_free (struct input *o);
static int       bz2_input_read (struct input *o, void *buf, unsigned count);
static long long bz2_input_seek (struct input *o, long long offset, int whence);

static const struct input_type bz2_input_type = {
	.free	= bz2_input_free,
	.read	= bz2_input_read,
	.seek	= bz2_input_seek,
};

struct bz2_input {
	struct input core;

	bz_stream s;
	char buf[BUFSIZ];
};

int input_push_bz2 (struct input **input)
{
	struct bz2_input *o;

	if ((o = malloc (sizeof (*o))) == NULL)
		return 0;

	o->core.type = &bz2_input_type;
	o->core.next = *input;

	o->s.next_in  = o->buf;
	o->s.avail_in = 0;

	o->s.bzalloc = NULL;
	o->s.bzfree  = NULL;
	o->s.opaque  = NULL;

	switch (BZ2_bzDecompressInit (&o->s, 0, 0)) {
	case BZ_OK:		*input = &o->core; return 1;
	case BZ_MEM_ERROR:	errno = ENOMEM; break;
	default:		errno = EINVAL; break;
	}

	free (o);
	return 0;
}

static void bz2_input_free (struct input *O)
{
	struct bz2_input *o = (void *) O;

	BZ2_bzDecompressEnd (&o->s);
	free (o);
}

static int bz2_input_read (struct input *O, void *buf, unsigned count)
{
	struct bz2_input *o = (void *) O;
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

		ret = BZ2_bzDecompress (&o->s);
	}
	while (ret == BZ_OK && o->s.avail_out > 0);

	switch (ret) {
	case BZ_OK:
	case BZ_OUTBUFF_FULL:
	case BZ_STREAM_END:	return count - o->s.avail_out;
	case BZ_MEM_ERROR:	errno = ENOMEM; break;
	default:		errno = EILSEQ; break;
	}

	return -1;
}

static long long bz2_input_seek (struct input *o, long long offset, int whence)
{
	errno = ENOSYS;
	return -1;
}
