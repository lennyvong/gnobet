package utils

import "reflect"

func IsArray(arr interface{}) bool {
	t := reflect.TypeOf(arr)

	return t.Kind() == reflect.Slice
}
