local IsEmpty = CPK.Table.IsEmpty
local Inverse = CPK.FP.Inverse

--- @type fun(tbl: table): boolean
CPK.Table.IsNotEmpty = Inverse(IsEmpty)
