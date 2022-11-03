/*
 * Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef YONK_INPUT_H
#define YONK_INPUT_H  1

#include <limits.h>
#include <stddef.h>

struct input {
	const struct input_type *type;
	struct input *next;
};

struct input_type {
	void      (*free) (struct input *o);
	int       (*read) (struct input *o, void *buf, unsigned count);
	long long (*seek) (struct input *o, long long offset, int whence);
};

static inline int input_read (struct input *o, void *buf, size_t count)
{
	if (count > INT_MAX)
		count = INT_MAX;

	return o->type->read (o, buf, count);
}

static inline struct input *input_pop (struct input *o)
{
	struct input *next = o->next;

	o->type->free (o);

	return next;
}

static inline void input_free (struct input *o)
{
	for (; o != NULL; o = input_pop (o)) {}
}

static inline
long long input_seek (struct input *o, long long offset, int whence)
{
	return o->type->seek (o, offset, whence);
}

#endif  /* YONK_INPUT_H */
