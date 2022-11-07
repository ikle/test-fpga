/*
 * LZ4 Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>

#include <yonk/input/lz4.h>

#include <lz4frame.h>

static void      lz4_input_free (struct input *o);
static int       lz4_input_read (struct input *o, void *buf, unsigned count);
static long long lz4_input_seek (struct input *o, long long offset, int whence);

static const struct input_type lz4_input_type = {
	.free	= lz4_input_free,
	.read	= lz4_input_read,
	.seek	= lz4_input_seek,
};

struct lz4_input {
	struct input core;

	LZ4F_decompressionContext_t s;

	char *next;
	size_t avail;
	char buf[BUFSIZ];
};

int input_push_lz4 (struct input **input)
{
	struct lz4_input *o;
	LZ4F_errorCode_t ret;

	if ((o = malloc (sizeof (*o))) == NULL)
		return 0;

	o->core.type = &lz4_input_type;
	o->core.next = *input;

	o->avail = 0;

	ret = LZ4F_createDecompressionContext (&o->s, LZ4F_VERSION);
	if (LZ4F_isError (ret))
		goto no_ctx;

	*input = &o->core;
	return 1;
no_ctx:
	errno = ENOMEM;
	free (o);
	return 0;
}

static void lz4_input_free (struct input *O)
{
	struct lz4_input *o = (void *) O;

	LZ4F_freeDecompressionContext (o->s);
	free (o);
}

static int lz4_input_read (struct input *O, void *buf, unsigned count)
{
	struct lz4_input *o = (void *) O;
	size_t in_len, out_len = count, ret;

	if (o->avail == 0) {
		ret = input_read (o->core.next, o->buf, sizeof (o->buf));
		if (ret < 0)
			return -1;

		o->next  = o->buf;
		o->avail = ret;
	}

	in_len = o->avail;
	ret = LZ4F_decompress (o->s, buf, &out_len, o->next, &in_len, NULL);
	if (LZ4F_isError (ret)) {
		errno = EILSEQ;
		return -1;
	}

	o->next  += in_len;
	o->avail -= in_len;
	return out_len;
}

static long long lz4_input_seek (struct input *o, long long offset, int whence)
{
	errno = ENOSYS;
	return -1;
}
