local ffi = require("ffi")

ffi.cdef[[
  /* From our library */
  typedef struct Person Person;
  Person* new_person(const char* name, const int age);
  void delete_person(Person* p);
  char* name(const Person* p);
  int age(const Person* p);

  typedef struct { 
      string name;
      int age;} PP;

  /* From the C library */
  void free(void*);
]]

local C = ffi.C

local PersonWrapper = {}
PersonWrapper.__index = PersonWrapper

local function Person(...)
  local self = {super = C.new_person(...)}
  ffi.gc(self.super, C.delete_person)
  return setmetatable(self, PersonWrapper)
end

function PersonWrapper.name(self)
  local name = C.name(self.super)
  ffi.gc(name, C.free)
  return ffi.string(name)
end

function PersonWrapper.age(self)
  return C.age(self.super)
end

local person = Person("Mark Twain", 74)
io.write(string.format("'%s' is %d years old\n",
                       person:name(),
                       person:age()))
