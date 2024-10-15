CPK.Table = CPK.Module()

--- @alias CPK.Table.Mapper<Val, Key, Res> fun(val: Val, key: Key): Res
--- @alias CPK.Table.Reducer<Val, Key, Res> fun(acc: Res, val: Val, key: Key): Res
--- @alias CPK.Table.Consumer<Val, Key> fun(val: Val, key: Key): any
--- @alias CPK.Table.Predicate<Val, Key> fun(val: Val, key: Key): boolean

