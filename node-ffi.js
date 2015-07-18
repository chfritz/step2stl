var FFI = require('ffi'),
    ArrayType = require('ref-array'),
    Struct = require('ref-struct'),
    ref = require('ref');

var voidPtr = ref.refType(ref.types.void);

exports.CONSTANTS = {
};

var libFile;
if (os.platform() == "darwin") {
    libFile = 'step2stl.so.dylib';
} else if (os.platform() == "linux") {
    libFile = 'step2stl.so';
}

exports.step2stl = new FFI.Library(libFile, {
    step2stl: [ref.types.int32, [
        ref.types.CString,
        ref.types.CString,
    ]],
});

