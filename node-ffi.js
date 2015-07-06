var FFI = require('ffi'),
    ArrayType = require('ref-array'),
    Struct = require('ref-struct'),
    ref = require('ref');

var voidPtr = ref.refType(ref.types.void);

exports.CONSTANTS = {
};


exports.step2stl = new FFI.Library('step2stl.so.dylib', {
  step2stl: [ref.types.int32, [
    ref.types.CString,
    ref.types.CString,
  ]],
});

