/*
 * XZ Stream Test
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <errno.h>
#include <stdio.h>
#include <string.h>

#include <yonk/input/file.h>
#include <yonk/input/xz.h>

static int test_xz (const char *path)
{
	struct input *o;
	char buf[128];
	int len;

	if ((o = input_open_file (path)) == NULL) {
		fprintf (stderr, "E: %s: %s\n", path, strerror (errno));
		return 1;
	}

	if (!input_push_xz (&o)) {
		perror ("E: cannot push XZ decoder");
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
	return test_xz ("input-xz-test-data.xz") ? 0 : 1;
}
