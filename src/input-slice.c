/*
 * Input Stream Slice
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <errno.h>
#include <stdlib.h>

#include <yonk/input-slice.h>

static void      slice_input_free (struct input *o);
static int       slice_input_read (struct input *o, void *buf, unsigned count);
static long long slice_input_seek (struct input *o, long long offset, int whence);

static const struct input_type slice_input_type = {
	.free	= slice_input_free,
	.read	= slice_input_read,
	.seek	= slice_input_seek,
};

struct slice_input {
	struct input core;
	input_size_t avail;
};

int input_push_slice (struct input **input, input_size_t len)
{
	struct slice_input *o;

	if ((o = malloc (sizeof (*o))) == NULL)
		return 0;

	o->core.type = &slice_input_type;
	o->core.next = *input;

	o->avail = len;

	*input = &o->core;
	return 1;
}

static void slice_input_free (struct input *O)
{
	struct slice_input *o = (void *) O;

	free (o);
}

static int slice_input_read (struct input *O, void *buf, unsigned count)
{
	struct slice_input *o = (void *) O;
	int len;

	if (count > o->avail)
		count = o->avail;

	if ((len = input_read (o->core.next, buf, count)) > 0)
		o->avail -= len;

	return len;
}

static long long slice_input_seek (struct input *O, long long offset, int whence)
{
	errno = ENOSYS;
	return -1;
}
