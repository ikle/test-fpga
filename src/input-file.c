/*
 * File Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <stdlib.h>

#include <fcntl.h>
#include <unistd.h>

#include <yonk/input/file.h>

static void      file_input_free (struct input *o);
static int       file_input_read (struct input *o, void *buf, unsigned count);
static long long file_input_seek (struct input *o, long long offset, int whence);

static const struct input_type file_input_type = {
	.free	= file_input_free,
	.read	= file_input_read,
	.seek	= file_input_seek,
};

struct file_input {
	struct input core;
	int fd;
};

struct input *input_open_file (const char *path)
{
	struct file_input *o;

	if ((o = malloc (sizeof (*o))) == NULL)
		NULL;

	o->core.type = &file_input_type;

	if ((o->fd = open (path, O_RDONLY | O_CLOEXEC)) == -1)
		goto no_open;

	return &o->core;
no_open:
	free (o);
	return NULL;
}

static void file_input_free (struct input *O)
{
	struct file_input *o = (void *) O;

	close (o->fd);
	free (o);
}

static int file_input_read (struct input *O, void *buf, unsigned count)
{
	struct file_input *o = (void *) O;

	return read (o->fd, buf, count);
}

static long long file_input_seek (struct input *O, long long offset, int whence)
{
	struct file_input *o = (void *) O;

	return lseek (o->fd, offset, whence);
}
