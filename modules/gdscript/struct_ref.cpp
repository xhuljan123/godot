/**************************************************************************/
/*  struct_ref.cpp                                                        */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             GODOT ENGINE                               */
/*                        https://godotengine.org                         */
/**************************************************************************/
/* Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md). */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/

#include "struct_ref.h"

#include "core/object/class_db.h"
#include "core/object/script_instance.h"

String StructRef::assign_from_dictionary(const Dictionary &p_data) {
	ScriptInstance *instance = get_script_instance();
	if (instance == nullptr) {
		return "StructRef has no script, so it has no variables to assign.";
	}
	for (const KeyValue<Variant, Variant> &kv : p_data) {
		if (kv.key.get_type() != Variant::STRING && kv.key.get_type() != Variant::STRING_NAME) {
			return vformat(R"(Invalid key "%s": keys must be variable names.)", kv.key);
		}
		const StringName name = kv.key;
		bool is_valid = false;
		const Variant::Type property_type = instance->get_property_type(name, &is_valid);
		if (!is_valid) {
			return vformat(R"(The class has no variable named "%s".)", name);
		}
		// Strict check (`set()` alone would accept lossy conversions, like a String to an int).
		const Variant::Type value_type = kv.value.get_type();
		if (property_type != Variant::NIL && value_type != property_type && !(property_type == Variant::OBJECT && value_type == Variant::NIL) && !Variant::can_convert_strict(value_type, property_type)) {
			return vformat(R"(Cannot assign a value of type "%s" to variable "%s" of type "%s".)", Variant::get_type_name(value_type), name, Variant::get_type_name(property_type));
		}
		if (!instance->set(name, kv.value)) {
			return vformat(R"(Cannot assign a value of type "%s" to variable "%s".)", Variant::get_type_name(kv.value.get_type()), name);
		}
	}
	return String();
}

bool StructRef::assign(const Dictionary &p_data) {
	const String error = assign_from_dictionary(p_data);
	ERR_FAIL_COND_V_MSG(!error.is_empty(), false, error);
	return true;
}

void StructRef::_bind_methods() {
	ClassDB::bind_method(D_METHOD("assign", "data"), &StructRef::assign);
}
