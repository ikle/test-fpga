/*
 * XZ Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>

#include <yonk/input-xz.h>

#include <lzma.h>

static void      xz_input_free (struct input *o);
static int       xz_input_read (struct input *o, void *buf, unsigned count);
static long long xz_input_seek (struct input *o, long long offset, int whence);

static const struct input_type xz_input_type = {
	.free	= xz_input_free,
	.read	= xz_input_read,
	.seek	= xz_input_seek,
};

struct xz_input {
	struct input core;

	lzma_stream s;
	unsigned char buf[BUFSIZ];
};

int input_push_xz (struct input **input)
{
	const lzma_stream s = LZMA_STREAM_INIT;
	struct xz_input *o;

	if ((o = malloc (sizeof (*o))) == NULL)
		return 0;

	o->core.type = &xz_input_type;
	o->core.next = *input;

	o->s = s;

	switch (lzma_auto_decoder (&o->s, UINT64_MAX, LZMA_CONCATENATED)) {
	case LZMA_OK:		*input = &o->core; return 1;
	case LZMA_MEM_ERROR:	errno = ENOMEM; break;
	default:		errno = EINVAL; break;
	}

	free (o);
	return 0;
}

static void xz_input_free (struct input *O)
{
	struct xz_input *o = (void *) O;

	lzma_end (&o->s);
	free (o);
}

static int xz_input_read (struct input *O, void *buf, unsigned count)
{
	struct xz_input *o = (void *) O;
	lzma_action action = LZMA_RUN;
	int ret;

	o->s.next_out  = buf;
	o->s.avail_out = count;

	do {
		if (o->s.avail_in == 0) {
			ret = input_read (o->core.next, o->buf, sizeof (o->buf));
			if (ret < 0)
				return -1;

			action = ret == 0 ? LZMA_FINISH : action;

			o->s.next_in  = o->buf;
			o->s.avail_in = ret;
		}

		ret = lzma_code (&o->s, action);
	}
	while (ret == LZMA_OK && o->s.avail_out > 0);

	switch (ret) {
	case LZMA_OK:
	case LZMA_BUF_ERROR:
	case LZMA_STREAM_END:	return count - o->s.avail_out;
	case LZMA_MEM_ERROR:	errno = ENOMEM; break;
	default:		errno = EILSEQ; break;
	}

	return -1;
}

static long long xz_input_seek (struct input *o, long long offset, int whence)
{
	errno = ENOSYS;
	return -1;
}
