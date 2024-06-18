# Datum in postgres

```cpp
/*
 * A Datum contains either a value of a pass-by-value type or a pointer to a
 * value of a pass-by-reference type.  Therefore, we require:
 *
 * sizeof(Datum) == sizeof(void *) == 4 or 8
 *
 * The macros below and the analogous macros for other types should be used to
 * convert between a Datum and the appropriate C type.
 */

typedef uintptr_t Datum;
```

in postgres, `Datum` is the generic type. you could use the `DatumGet*` macros to cast it to one of the specific data types.

for example:

```cpp
DatumGetBool()
DatumGetInt32()
```
