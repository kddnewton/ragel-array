#include <ruby.h>

typedef struct ragel_array {
  uint8_t *data;
  size_t size;
} ragel_array_t;

static void ragel_array_deallocate(ragel_array_t *array) {
  free(array->data);
  free(array);
}

static VALUE ragel_array_allocate(VALUE klass) {
  ragel_array_t *array = malloc(sizeof(ragel_array_t));

	return Data_Wrap_Struct(klass, NULL, ragel_array_deallocate, array);
}

static VALUE ragel_array_initialize(VALUE self, VALUE rb_string, VALUE rb_size) {
  Check_Type(rb_string, T_STRING);
  Check_Type(rb_size, T_FIXNUM);

  ragel_array_t *array;
  Data_Get_Struct(self, ragel_array_t, array);

  long size = FIX2LONG(rb_size);
  array->data = calloc(size, sizeof(uint8_t));
  array->size = size;

  char *string = StringValueCStr(rb_string);
  long length = RSTRING_LEN(rb_string);
  char buffer[5];

  for (long data_index = 0, num_start = 0, num_end = 0; data_index < size; data_index += 1) {
    while (string[num_end++] != ' ' && num_end < length);
    strncpy(buffer, string + num_start, num_end - num_start);

    array->data[data_index] = (uint8_t) atoi(buffer);
    num_start = num_end;
  }

  return self;
}

static VALUE ragel_array_get(VALUE self, VALUE rb_index) {
  Check_Type(rb_index, T_FIXNUM);

  ragel_array_t *array;
  Data_Get_Struct(self, ragel_array_t, array);

  long index = FIX2LONG(rb_index);
  if (index < 0 || (unsigned) index >= array->size) {
    return Qnil;
  }

  return LONG2FIX(array->data[index]);
}

void Init_ragel_array(void) {
  VALUE rb_cRagel = rb_define_module("Ragel");
  VALUE rb_cRagelArray = rb_define_class_under(rb_cRagel, "Array", rb_cObject);

  rb_define_alloc_func(rb_cRagelArray, ragel_array_allocate);
  rb_define_method(rb_cRagelArray, "initialize", ragel_array_initialize, 2);
  rb_define_method(rb_cRagelArray, "[]", ragel_array_get, 1);
}
