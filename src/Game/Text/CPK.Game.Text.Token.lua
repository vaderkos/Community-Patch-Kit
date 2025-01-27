local newline = '[NEWLINE]'
local dashline = '----------------'

--- @enum CPK.Game.Text.Token
local Token = {
	TAB = '[TAB]',
	SPACE = '[SPACE]',
	NEWLINE = newline,
	DIVIDER = newline .. dashline .. newline,
	DASHLINE = dashline,
}

CPK.Game.Text.Token = Token