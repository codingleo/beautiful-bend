import Base

type Package is Data:
  Envelope{}
  Parcel{kilograms: U32}

type Shipment is Data:
  Collect{}
  Standard{package: Package}
  Express{package: Package}

def package_cost(package: Package) -> U32:
  match package:
    case Envelope{}:
      2
    case Parcel{kilograms}:
      (3 + 2 * kilograms : U32)

def shipping(shipment: Shipment) -> U32:
  match shipment:
    case Collect{}:
      0
    case Standard{Envelope{}}:
      2
    case Standard{Parcel{kilograms}}:
      (3 + 2 * kilograms : U32)
    case Express{package}:
      (5 + package_cost(package) : U32)

def main() -> U32 & U32 & U32 & U32 & U32:
  (shipping(Collect{}), shipping(Standard{Envelope{}}), shipping(Standard{Parcel{0}}), shipping(Standard{Parcel{3}}), shipping(Express{Parcel{3}}))
