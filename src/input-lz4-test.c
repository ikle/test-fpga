/*
 * LZ4 Stream Test
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <errno.h>
#include <stdio.h>
#include <string.h>

#include <yonk/input/file.h>
#include <yonk/input/lz4.h>

static int test_lz4 (const char *path)
{
	struct input *o;
	char buf[128];
	int len;

	if ((o = input_open_file (path)) == NULL) {
		fprintf (stderr, "E: %s: %s\n", path, strerror (errno));
		return 1;
	}

	if (!input_push_lz4 (&o)) {
		perror ("E: cannot push LZ4 decoder");
		goto error;
	}

	while ((len = input_read (o, buf, sizeof (buf))) > 0)
		printf ("%.*s", len, buf);

	if (len < 0) {
		perror ("E: cannot decode");
		goto error;
	}

	input_free (o);
	return 1;
error:
	input_free (o);
	return 0;
}

int main (int argc, char *argv[])
{
	return test_lz4 ("input-lz4-test-data.lz4") ? 0 : 1;
}
