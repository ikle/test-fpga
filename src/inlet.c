/*
 * Buffered Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <stdlib.h>

#include <yonk/inlet.h>

struct inlet *inlet_open (struct input *input, size_t size)
{
	struct inlet *o;

	if ((o = malloc (sizeof (*o))) == NULL)
		return o;

	if ((o->buf = malloc (size)) == NULL)
		goto no_buf;

	o->size = size;
	o->pos  = o->buf;
	o->end  = o->buf + size;
	return o;
no_buf:
	free (o);
	return NULL;
}

void inlet_close (struct inlet *o)
{
	if (o == NULL)
		return;

	free (o->buf);
	free (o);
}
