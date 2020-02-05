extends Node

enum {
	e_column_type_int = 0,
	e_column_type_string
}

class cColumn:
	var m_name

class cRow:
	var m_id
	var m_columns = []

	func add_column(idx, column_text):
		var cell = null
		if(idx == 0):
			cell = Label.new()
			cell.set_custom_minimum_size(Vector2(20, 20))
			cell.set_size(Vector2(100, 20))
			cell.set_align(Label.ALIGN_RIGHT)
			cell.set_valign(Label.VALIGN_CENTER)
			cell.set_text(str(m_id))
			m_columns.push_back(cell)
		else:
			cell = load("res://table_cell.tscn").instance()
			cell.set_text(column_text)
			m_columns.push_back(cell)
		return cell
