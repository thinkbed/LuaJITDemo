local ffi = require("ffi")

ffi.cdef[[
  /* From our library */
  typedef struct {
      int a;
  } A;

  typedef struct {
      float f;
  }B;

  typedef struct {
      union {
          A m_a;
          B m_b;
      };
  }C;

]]

local C = ffi.C

function onTDRTest(c)
    print(c)
    --print(ptr_C)
    lc = ffi.cast("C*", c)
    print(lc)

    print("c.m_a.a="..lc.m_a.a)

    lc.m_b.f = 12.56
end

