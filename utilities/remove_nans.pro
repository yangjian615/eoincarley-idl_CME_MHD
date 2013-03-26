pro remove_nans, input, output, number_positions, nan_positions

	true_false = finite(input) ;0s for NaN, 1s for number
	number_positions = where(true_false eq 1)
	nan_positions = where(true_false eq 0)
	output = input[number_positions]


END