class_name Date extends Node

### Reason for commenting stated in 'set_year()'
#static var MIN_YEAR_VALUE: int = 2025

#region = PUBLIC =

var day:   int = 0: set = _set_day
var month: int = 0: set = _set_month
var year:  int = 0: set = _set_year


### Constructor
func _init(_day: int, _month: int, _year: int) -> void:
	### Day setting depends on month, month setting depends on year.
	### Thus, we set them in reverse order.
	year  = _year
	month = _month
	day   = _day


### DD.MM.YYYY
func output() -> void:
	var day_str:   String = ""
	var month_str: String = ""
	
	if (day < 10):
		day_str = "0"
	day_str += str(day)
	
	if (month < 10):
		month_str = "0"
	month_str += str(month)
	
	print(day_str + "." + month_str + "." + str(year))

#endregion


#region = PRIVATE =

### TODO: Here's what I noticed.
### When adding 61 days, do we skip 1 or 2 months?
### While it's fairly straightforward with years, I guess adding days should come in steps.
### Oh, and don't forget leap years.

var _month_length: int = 0

### What must be understood about setter args:
### 'new_value' is the value **that we're trying to set**,
### not what we add or substract from it.

func _set_day(new_value: int) -> void:
	if (month == 0 or _month_length == 0):
		push_error("Month & month length must be set first!")
		get_tree().quit()
	
	if (new_value > _month_length):
		pass


func _set_month(new_value: int) -> void:
	if (year == 0):
		push_error("Year must be set first!")
		get_tree().quit()
		
	if (new_value > 12):
		year += new_value / 12
		month = new_value % 12
	elif (new_value < 1):
		# Might be VERY bugged
		year += -1 + new_value / 12   ### Resetting a month backwards like that is automatically at least -1 year
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


func _set_year(new_value: int) -> void:
	### Commented part raises a concern:
	### it's just too easy to cause an error via normal usage.
	### = Let's leave it out for now. =
	#if (new_value < MIN_YEAR_VALUE):
		#push_error("Year can't be less than " + str(MIN_YEAR_VALUE) + "!")
		#get_tree().quit()
	year = new_value

#endregion
