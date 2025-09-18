class_name Date
extends    Node

### Reason for commenting stated in 'set_year()'
#static var MIN_YEAR_VALUE: int = 2025

#region = Public =

var day:   int = 0:
	set = _set_day
var month: int = 0:
	set = _set_month
var year:  int = 0:
	set = _set_year


### Ctor
func _init(_day: int = 0, _month: int = 0, _year: int = 0) -> void:
	### TODO: setting it based on current date
	### Day setting depends on month, month setting depends on year.
	### Thus, we set them in reverse order.
	year  = _year
	month = _month
	day   = _day


## Return formatted DD.MM.YYYY
func dd_mm_yyyy() -> String:
	var day_str:   String = ""
	var month_str: String = ""
	
	if (day < 10):
		day_str = "0"
	day_str += str(day)
	
	if (month < 10):
		month_str = "0"
	month_str += str(month)
	
	return day_str + "." + month_str + "." + str(year)

#endregion


#region = Private =

var _month_length: int = 0

### What must be understood about setter args:
### 'new_value' is the value **that we're trying to set**,
### not what we add or substract from it.

### 'day' setter; NOT MEANT TO BE USED EXTERNALLY
func _set_day(new_value: int) -> void:
	if (month == 0 or _month_length == 0):
		push_error("Month & month length must be set first!")
		get_tree().quit()
	
	### If increased
	while (new_value > _month_length): ### 1 month at a time
		new_value -= _month_length
		month += 1
		day = new_value ### To not wrap 'while's in 'if's.
	
	### If decreased
	while (new_value < -_month_length): ### 1 month at a time
		# Might be VERY bugged
		month -= 1
		day = _month_length - new_value ### To not wrap 'while's in 'if's.


### 'month' setter, also sets '_month_length'; NOT MEANT TO BE USED EXTERNALLY
func _set_month(new_value: int) -> void:
	if (year == 0):
		push_error("Year must be set first!")
		get_tree().quit()
		
	if (new_value > 12):
		year += new_value / 12
		month = new_value % 12
	elif (new_value < 1):
		# Might be VERY bugged
		### NOTE: I don't like the '-=' part
		year -= -1 + new_value / 12   ### Resetting a month backwards like that is automatically at least -1 year
		month = 12 - (-new_value % 12) ### ('-' for correct '%') If we substracted a month and got 0, it's 12. If we got -13, it's 11.
	else:
		month = new_value
	
	_set_month_length()


# 1  2  3  4  5  6  7 month
# 31 xx 31 30 31 30 31
# =========================
# 8  9  10 11 12 month
# 31 30 31 30 31
### Conc.: 1-7 matches 8-12 with exclusion of February,
### This lets us use maths and not a lookup table.

### '_month_length' *calculator*; NOT MEANT TO BE USED EXTERNALLY
func _set_month_length() -> void:
	if (month == 0):
		push_error("Month must be set first!")
		get_tree().quit()
	
	### February
	elif (month == 2):
		### Leap year
		if (year % 4 == 0):
			_month_length = 29
		else:
			_month_length = 28
		return
	
	### For explanation of lines below, consult the comments above this function.
	var _month_math_substitute: int = month
	if (month >= 8):
		_month_math_substitute %= 7
	
	_month_length = 30 + (_month_math_substitute % 2)


### 'year' setter; NOT MEANT TO BE USED EXTERNALLY
func _set_year(new_value: int) -> void:
	### Commented part raises a concern:
	### it's just too easy to cause an error via normal usage.
	### = Let's leave it out for now. =
	#if (new_value < MIN_YEAR_VALUE):
		#push_error("Year can't be less than " + str(MIN_YEAR_VALUE) + "!")
		#get_tree().quit()
	year = new_value

#endregion
