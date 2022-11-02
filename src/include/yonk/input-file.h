/*
 * File Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef YONK_INPUT_FILE_H
#define YONK_INPUT_FILE_H  1

#include <yonk/input.h>

struct input *input_open_file (const char *path);

#endif  /* YONK_INPUT_FILE_H */
