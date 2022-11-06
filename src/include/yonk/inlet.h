/*
 * Buffered Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef YONK_INLET_H
#define YONK_INLET_H  1

#include <string.h>

#include <yonk/input.h>

struct inlet {
	struct input *s;
	unsigned char *buf;
	size_t size;
	unsigned char *pos, *end;
};

struct inlet *inlet_open (struct input *input, size_t size);
void inlet_close (struct inlet *o);

static inline int inlet_get (struct inlet *o, unsigned char *y)
{
	int len;

	if (o->pos >= o->end) {
		if ((len = input_read (o->s, o->buf, o->size)) <= 0)
			return 0;

		o->pos = o->buf;
		o->end = o->buf + len;
	}

	*y = *o->pos++;
	return 1;
}

static inline int inlet_read (struct inlet *o, void *buf, size_t count)
{
	int len = o->end - o->pos;

	if (len <= 0) {
		if ((len = input_read (o->s, o->buf, o->size)) <= 0)
			return len;

		o->pos = o->buf;
		o->end = o->buf + len;
	}

	count = count > len ? len : count;

	memcpy (buf, o->pos, count);
	o->pos += count;
	return count;
}

#endif  /* YONK_INLET_H */
