/*
 * LZ4 Input Stream
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef YONK_INPUT_LZ4_H
#define YONK_INPUT_LZ4_H  1

#include <yonk/input.h>

int input_push_lz4 (struct input **input);

#endif  /* YONK_INPUT_LZ4_H */
