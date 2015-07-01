// STEP Read Methods
#include <STEPControl_Reader.hxx>
#include <TopoDS_Shape.hxx>
// STL Read & Write Methods
#include <StlAPI_Writer.hxx>

Standard_Integer main (int argc, char *argv[]) {

  // Read from STEP
  STEPControl_Reader reader;
  IFSelect_ReturnStatus stat = reader.ReadFile(argv[1]);

  Standard_Integer NbRoots = reader.NbRootsForTransfer();
  Standard_Integer NbTrans = reader.TransferRoots();
  TopoDS_Shape Original_Solid = reader.OneShape();

  // Write to STL
  StlAPI_Writer stlWriter = StlAPI_Writer();
  // stlWriter.SetCoefficient(0.0001);
  stlWriter.ASCIIMode() = Standard_False;
  stlWriter.Write( Original_Solid, argv[2]);

}

