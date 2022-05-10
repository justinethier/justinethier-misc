const std = @import("std");

const ObjectType = enum {
  OBJ_INT,
  OBJ_PAIR,
};

const Object = struct {
  type: ObjectType,
  marked: u8
  // TODO: union
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}

