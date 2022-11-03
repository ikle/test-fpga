/*
 * Input Stream Slice
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef YONK_INPUT_SLICE_H
#define YONK_INPUT_SLICE_H  1

#include <yonk/input.h>

int input_push_slice (struct input **input, long long len);

#endif  /* YONK_INPUT_SLICE_H */
