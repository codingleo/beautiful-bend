import Base

type Rectangle is Data:
  Rectangle{width: U32, height: U32}

def dimensions(rectangle: Rectangle) -> U32 & U32:
  match rectangle:
    case Rectangle{+width, +height}:
      ((width * height : U32), (2 * (width + height : U32) : U32))

def main() -> (U32 & U32) & (U32 & U32) & (U32 & U32):
  (dimensions(Rectangle{0, 0}), dimensions(Rectangle{0, 4}), dimensions(Rectangle{3, 4}))
