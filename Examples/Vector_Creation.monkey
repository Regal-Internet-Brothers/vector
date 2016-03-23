Strict

Public

<<<<<<< HEAD
' Preprocessor related:
'#REFLECT_EVERYTHING = True

#If REFLECT_EVERYTHING
	#REFLECTION_FILTER = "regal.*"
#End

' Imports:
#If REFLECT_EVERYTHING
	Import reflection
#End

=======
' Imports:
>>>>>>> 75b17cb741117060de558e94086d7b6a73edbdb4
Import regal.vector

' Functions:
Function Main:Int()
<<<<<<< HEAD
	Local V2:= New Vector2D<Int>(1, 2)
	Local V3:= New Vector3D<Int>(V2.X, V2.Y, 3)
	Local V4:= New Vector4D<Int>(V3.X, V3.Y, V3.Z, 4)
=======
	Local V2:= New Vector2D<Int>(2, 3)
	Local V3:= New Vector3D<Int>(V2.X, V2.Y, 7)
	Local V4:= New Vector4D<Int>(V3.X, V3.Y, V3.Z, 11)
>>>>>>> 75b17cb741117060de558e94086d7b6a73edbdb4
	
	Print(V2)
	Print(V3)
	Print(V4)
	
	' Return the default response.
	Return 0
End