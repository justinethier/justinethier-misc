const std = @import("std");
const print = @import("std").debug.print;
const gpa = std.heap.GeneralPurposeAllocator(.{});
const allocator = gpa.allocator();

const STACK_MAX = 256;
const INIT_OBJ_NUM_MAX = 8;

const ObjectType = enum {
    OBJ_INT,
    OBJ_PAIR,
};

const Object = struct {
    type: ObjectType,
    marked: u8,
    data: Data,

    pub fn init() !*Object {
        // based off example from https://ziglearn.org/chapter-2/
        var obj = try allocator.alloc(Object, 1);
        return obj;
    }
};

const Data = union { value: i32, pair: struct { head: ?*Object, tail: ?*Object } };

//const Pair = struct {
//    head: *Object,
//    tail: *Object,
//};

const VM = struct {
    stack: ?[*]Object,
    //int stackSize; // not needed, have stack.len

    // The first object in the linked list of all objects on the heap. */
    firstObject: ?*Object,

    // The total number of currently allocated objects. */
    numObjects: u32,

    // The number of objects required to trigger a GC. */
    maxObjects: u32,

    // TODO: pub fn init() *VM {}
    // TODO: void push(VM* vm, Object* value) {
    // TODO: Object* pop(VM* vm) {
};

test "test 1" {
    print("Test 1: Objects on stack are preserved.\n", .{});
    var vm = VM{
        .stack = null,
        .firstObject = null,
        .numObjects = 0,
        .maxObjects = STACK_MAX,
    };

    //  VM* vm = newVM();
    //  pushInt(vm, 1);
    //  pushInt(vm, 2);
    //
    //  gc(vm);
    //  assert(vm->numObjects == 2, "Should have preserved objects.");
    //  freeVM(vm);

    try std.testing.expect(vm.numObjects == 0);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}
