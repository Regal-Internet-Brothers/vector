Strict

Public

' Imports:
Import regal.vector

' Functions:
Function Main:Int()
	Local V2:= New Vector2D<Int>(1, 2)
	Local V3:= New Vector3D<Int>(V2.X, V2.Y, 3)
	Local V4:= New Vector4D<Int>(V3.X, V3.Y, V3.Z, 4)
	
	Print(V2)
	Print(V3)
	Print(V4)
	
	' Return the default response.
	Return 0
End