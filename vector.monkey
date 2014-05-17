Strict

Public

' Imports:

' BRL:
Import brl.stream

' ImmutableOctet:
Import util

#Rem
' Aliases:
Alias Vector = system.ManualVector
'Alias Vec1D = system.Vector1D
Alias Vec2D = system.Vector2D
Alias Vec3D = system.Vector3D
Alias Vec4D = system.Vector4D
'Alias Vec = system.Vector1D
'Alias Vec1 = system.Vector1D
Alias Vec2 = system.Vector2D
Alias Vec3 = system.Vector3D
Alias Vec4 = system.Vector4D

Alias ManualVec = system.ManualVector
#End

' Classes:
Class AbstractVector<T>
	' Constant variables:
	Const XPOS:Int = 0
	Const QuoteChar:Int = 34 ' Also known as ' " '.
	
	Const Space:String = " "
	Const Comma:String = ","
	Const SingleQuote:String = "'"
	Const VECTORSIZE:Int = 1
	Const AUTO:Int		= -1
	
	' Global variables:
	Global Quote:String = String.FromChar(QuoteChar)
	Global NIL:T

	' Functions:
	Function Name:String()
		Return "Vector(Abstract)"
	End
	
	Function DotProductNormalized:T(V1:AbstractVector<T>, V2:AbstractVector<T>)
		Return V1.DotProductNormalized(V2)
	End

	' Constructor(s) (Public):
	Method New(Size:Int)
		CreateData(Size)
	End
	
	Method New(Info:T[])
		AssignByRef(Info)
	End
	
	Method New(V:AbstractVector<T>, Size:Int=AUTO)
		If (Size = AUTO) Then
			Size = V.Data.Length()
		Endif
		
		CreateData(Size)
		
		Assign(V)
	End
	
	' Constructor(s) (Private):
	Private
	
	Method CreateData:Void(Size:Int)
		Data = New T[Size]
		
		Return
	End
	
	Public

	' Methods:
	Method Clone:AbstractVector<T>()
		Return New AbstractVector<T>(Data)
	End
	
	Method Clone:Void(V:AbstractVector<T>)
		Assign(V)
		
		Return
	End
	
	Method Copy:Void(V:AbstractVector<T>)
		Clone(V)
		
		Return
	End
	
	Method Copy:Void(Info:T[], Size:Int=0)
		Assign(Info, Size)
		
		Return
	End
	
	Method Assign:Void(V:AbstractVector<T>)
		If (V = Null) Then Return
		
		Assign(V.Data)
	
		Return
	End
	
	Method Assign:Void(Info:T[], Size:Int=0)
		If (Size = 0) Then Size = Info.Length()
		
		For Local I:Int = 0 Until Min(Size, Data.Length())
			Self.Data[I] = Info[I]
		Next
		
		'AssignByRef(Info.Resize(Size))
		
		Return
	End
	
	Method AssignByRef:Void(Info:T[])
		Self.Data = Info
		
		Return
	End
	
	Method GetData:T(Index:Int)
		' Local variable(s):
		Local DLength:Int = Self.Data.Length()
		
		If (Index+1 > DLength Or Index < 0) Then
			#If CONFIG = "debug"
				Error("Error: Attempted to access invalid element.")
			#End
			
			Return NIL
		Endif
		
		Return Self.Data[Index]
	End
	
	Method GetData:T[]()
		Return Data
	End
	
	Method SetData:Void(Index:Int, Info:T)
		#Rem
		If ((Self.Data.Length()-1) < Index) Then
			DebugStop()
		Endif
		#End
		
		Self.Data[Index] = Info		
		
		Return
	End
	
	Method Zero:Void(VDataLength:Int=AUTO, Offset:Int=XPOS)
		If (VDataLength = AUTO) Then
			VDataLength = Data.Length()
		Endif
		
		For Local I:Int = Offset Until VDataLength
			Data[I] = T(0)
		Next
		
		Return
	End
	
	Method Invert:Void(VDataLength:Int=AUTO, Offset:Int=XPOS)
		If (VDataLength = AUTO) Then
			VDataLength = Data.Length()
		Endif
		
		For Local I:Int = Offset Until VDataLength
			Data[I] = -Data[I]
		Next
		
		Return
	End
	
	Method ApplyMin:Void(Value:Float, VDataLength:Int=AUTO)
		If (VDataLength = AUTO) Then
			VDataLength = Data.Length()
		Endif
		
		For Local I:Int = 0 Until VDataLength
			Self.Data[I] = Min(Self.Data[I], Value)
		Next
		
		Return
	End
	
	Method ApplyMax:Void(Value:Float, VDataLength:Int=AUTO)
		If (VDataLength = AUTO) Then
			VDataLength = Data.Length()
		Endif
		
		For Local I:Int = 0 Until VDataLength
			Self.Data[I] = Max(Self.Data[I], Value)
		Next
		
		Return
	End
	
	Method ApplyClamp:Void(MinValue:Float, MaxValue:Float, VDataLength:Int=AUTO)
		If (VDataLength = AUTO) Then
			VDataLength = Data.Length()
		Endif
		
		For Local I:Int = 0 Until VDataLength
			Self.Data[I] = Clamp(Self.Data[I], MinValue, MaxValue)
		Next
		
		Return
	End
	
	' Add the input-vector to this vector:
	Method Add:Void(V:AbstractVector<T>, VDataLength:Int=AUTO)
		Add(V.Data, VDataLength)
		
		Return
	End
	
	Method Add:Void(A:T[], ALength:Int=AUTO)
		If (ALength = AUTO) Then
			ALength = A.Length()
		Endif
		
		For Local Index:Int = 0 Until Min(Data.Length(), ALength)
			Data[Index] += A[Index]
		Next
		
		Return
	End
	
	' Add by scalar, instead of by vector.
	Method Add:Void(F:T)
		For Local Index:Int = 0 Until Data.Length()
			Data[Index] += F
		Next
		
		Return
	End
	
	Method DeltaAdd:Void(V:AbstractVector<T>, Scalar:T, VDataLength:Int=AUTO)
		DeltaAdd(V.Data, Scalar, VDataLength)
		
		Return
	End
	
	Method DeltaAdd:Void(A:T[], Scalar:T, ALength:Int=AUTO)
		If (ALength = AUTO) Then
			ALength = A.Length()
		Endif
		
		For Local Index:Int = 0 Until Min(Data.Length(), ALength)
			Data[Index] += A[Index] * Scalar
		Next
		
		Return
	End
	
	Method DeltaAdd:Void(F:T, Scalar:T)
		For Local Index:Int = 0 Until Data.Length()
			Data[Index] += F * Scalar
		Next
		
		Return
	End
	
	Method Decelerate:Void(Deceleration:T, ALength:Int=AUTO, Offset:Int=XPOS)
		If (ALength = AUTO) Then
			ALength = Data.Length()
		Endif
		
		' Local variable(s):
		Local VelocityLength:Float = Length()
		
		For Local Index:Int = Offset Until ALength
			If (Data[Index] > 0.0) Then
				Data[Index] = Max(Data[Index]-(((Data[Index] / VelocityLength)*Deceleration)), 0.0)
			Else
				Data[Index] = Min(Data[Index]-(((Data[Index] / VelocityLength)*Deceleration)), 0.0)
			Endif
		Next
		
		Return
	End
	
	Method Accelerate:Void(V:AbstractVector<T>, Scalar:T, VDataLength:Int=AUTO)
		DeltaAdd(V, Scalar, VDataLength)
		
		Return
	End
	
	' Subtract the input-vector from this vector:
	Method Subtract:Void(V:AbstractVector<T>, VDataLength:Int=AUTO)
		Subtract(V.Data, VDataLength)
		
		Return
	End
	
	Method Subtract:Void(A:T[], ALength:Int=AUTO)
		If (ALength = AUTO) Then
			ALength = A.Length()
		Endif
		
		For Local Index:Int = 0 Until Min(Data.Length(), ALength)
			Data[Index] -= A[Index]
		Next
		
		Return
	End
	
	' Subtract by scalar, instead of by vector.
	Method Subtract:Void(F:T)
		For Local Index:Int = 0 Until Data.Length()
			Data[Index] -= F
		Next
		
		Return
	End
	
	Method Devide:Void(V:AbstractVector<T>, VDataLength:Int=AUTO)
		Devide(V.Data, VDataLength)
		
		Return
	End
	
	Method Devide:Void(A:T[], ALength:Int=AUTO)
		If (ALength = AUTO) Then
			ALength = A.Length()
		Endif
		
		For Local Index:Int = 0 Until Min(Data.Length(), ALength)
			Data[Index] /= A[Index]
		Next
		
		Return
	End
	
	Method Devide:Void(F:T)
		For Local Index:Int = 0 Until Data.Length()
			Data[Index] /= F
		Next
		
		Return
	End
	
	Method Multiply:Void(V:AbstractVector<T>, VDataLength:Int=AUTO)
		Multiply(V.Data, VDataLength)
		
		Return
	End
	
	Method Multiply:Void(A:T[], ALength:Int=AUTO)
		If (ALength = AUTO) Then
			ALength = A.Length()
		Endif
		
		For Local Index:Int = 0 Until Min(Data.Length(), ALength)
			Data[Index] *= A[Index]
		Next
		
		Return
	End
	
	Method Multiply:Void(F:T)
		For Local Index:Int = 0 Until Data.Length()
			Data[Index] *= F
		Next
		
		Return
	End
	
	Method Length:T(ALength:Int=AUTO)
		If (ALength = AUTO) Then
			ALength = Data.Length()
		Endif
		
		' Local variable(s):
		Local Sum:T = NIL
		
		For Local Index:Int = 0 Until ALength
			Sum += Data[Index]*Data[Index] ' Pow(..., 2)
		Next
		
		Return Sqrt(Sum)
	End
	
	Method LinearInterpolation:Void(V:AbstractVector<T>, t:T, VDataLength:Int=AUTO)
		LinearInterpolation(V.Data, t, VDataLength)
		
		Return
	End
	
	Method LinearInterpolation:Void(A:T[], t:T, ALength:Int=AUTO)
		If (ALength = AUTO) Then
			ALength = A.Length()
		Endif
		
		t = Clamp(t, T(0.0), T(1.0))
		
		For Local Index:Int = 0 Until Min(Data.Length(), ALength)
			Data[Index] = Data[Index] + (A[Index]-Data[Index]) * t
		Next
		
		Return
	End
	
	Method Normalize:Void()
		Normalize(Length())
		
		Return
	End
	
	Method Normalize:Void(Length:T)
		If (Length <> NIL) Then Length = 1.0 / Length
		
		Multiply(Length)
		
		Return
	End
	
	Method DotProduct:T(V:AbstractVector<T>, VDataLength:Int=AUTO)
		Return DotProduct(V.Data, VDataLength)
	End
	
	Method DotProduct:T(A:T[], ALength:Int=AUTO)
		If (ALength = AUTO) Then
			ALength = A.Length()
		Endif
		
		' Local variable(s):
		Local Sum:T = NIL
		
		For Local Index:Int = 0 Until Min(Data.Length(), ALength)
			Sum += Data[Index]*A[Index] ' Pow(..., 2)
		Next
		
		Return Sum
	End
	
	Method DotProductNormalized:T(V:AbstractVector<T>)
		' Local variable(s):
		Local Result:T
		
		Local V1:= New AbstractVector<T>(Self)
		Local V2:= New AbstractVector<T>(V)
		
		V1.Normalize()
		V2.Normalize()
		
		Result = V1.DotProduct(V2)
		
		V1 = Null
		V2 = Null
		
		' Return the result variable.
		Return Result
	End
	
	Method SubtractTowardsZero:Void(Time:T=T(1.0), VDataLength:Int=AUTO)
		If (VDataLength = AUTO) Then
			VDataLength = Data.Length()
		Endif
		
		' Ensure we have a valid delta.
		Time = Clamp(Time, T(0), T(1))
		
		For Local I:Int = 0 Until VDataLength
			If (Data[I] > T(0)) Then
				Data[I] = Max(Data[I]-(Data[I]*Time), T(0))
			Else
				Data[I] = Min(Data[I]-(Data[I]*Time), T(0))
			Endif
		Next
		
		Return
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool)
		Local OutStr:String
	
		If (Not GiveName) Then
			OutStr = String("X:" + Space + SingleQuote + String(GetData(XPOS)) + SingleQuote)
		Else
			OutStr = Name()
		Endif
		
		Return OutStr
	End
	
	Method Read:Bool(S:Stream, ReadSize:Int=0)
		If (S = Null) Then Return False
		If (S.Eof()) Then Return False
		
		If (ReadSize = 0) Then
			ReadSize = Self.Data.Length()
		Endif
		
		GenericUtilities<T>.Read(S, Self.Data, ReadSize)
		
		' Return the default response.
		Return True
	End
	
	Method Write:Bool(S:Stream, WriteSize:Bool=False)
		If (S = Null) Then Return False
		
		GenericUtilities<T>.Write(S, Self.Data, WriteSize)
		
		' Return the default response.
		Return True
	End
	
	' Properties (Public):
	Method Value:T() Property
		Return X()
	End
	
	Method Value:Void(Info:T) Property
		X(Info)
		
		Return
	End
	
	Method R:T() Property
		Return X()
	End
	
	Method R:Void(Info:T) Property
		X(Info)
		
		Return
	End
	
	Method Left:T() Property
		Return X()
	End
	
	Method Left:Void(Info:T) Property
		X(Info)
	End
	
	Method X:T() Property
		Return GetData(XPOS)
	End
	
	Method X:Void(Info:T) Property
		SetData(XPOS, Info)
	
		Return
	End
	
	Method Size:Int() Property
		Return Data.Length()
	End
	
	' Properties (Private):
	Private
	
	' Nothing so far.
	
	Public
	
	' Fields (Public):
	' Nothing so far.
	
	' Fields (Private):
	Private
	
	Field Data:T[]
	
	Public
End

#Rem
Class Vector1D<T>
	' Functions:
	Function Name:String()
		Return "Vector(1D)"
	End

	' Constructor(s):
	Method New()
		' Nothing so far.
	End
	
	Method New(Info:T)
		Self.Data = Info
	End
	
	Method New(V:Vector1D<T>)
		Self.Data = V.Data
	End
	
	' Methods:
	Method Clone:Vector1D<T>()
		Return New Vector1D<T>(Data)
	End
	
	Method ToString:String(GiveName:Bool)
		Local OutStr:String
	
		If (Not GiveName) Then
			OutStr = ("Value: " + String(Value()))
		Else
			OutStr = Name()
		Endif
		
		Return OutStr
	End

	' Properties:
	Method X:T() Property
		Return Value()
	End
	
	Method X:Void(Info:T) Property
		Value(Info)
	
		Return
	End
	
	Method Value:T() Property
		Return Data
	End
	
	Method Value:Void(Info:T) Property
		Self.Data = Info
	
		Return
	End
	
	' Fields(Private):
	Private
	
	Field Data:T
	
	Public
End
#End

Class Vector2D<T> Extends AbstractVector<T>
	' Constant variables:
	Const YPOS:Int = 1
	Const VECTORSIZE:Int = 2

	' Functions:
	Function Name:String()
		Return "Vector(2D)"
	End
	
	Function FromInts:Vector2D<T>(X:Int, Y:Int)
		Return New Vector2D<T>(T(X), T(Y))
	End
	
	Function FromFloats:Vector2D<T>(X:Float, Y:Float)
		Return New Vector2D<T>(T(X), T(Y))
	End
	
	' Constructor(s):	
	Method New()
		Super.New(VECTORSIZE)
	End
		
	Method New(Size:Int)
		Super.New(Size)
	End
		
	Method New(Info:T[])
		Super.New(Info)
	End
	
	Method New(V:AbstractVector<T>, Size:Int=VECTORSIZE)
		Super.New(V, Size)
	End
	
	Method New(X:T, Y:T, VECTORSIZE:Int=Vector2D<T>.VECTORSIZE)
		Super.New(VECTORSIZE)
		
		Self.X = X
		Self.Y = Y
	End
		
	' Methods:	
	Method Clone:AbstractVector<T>()
		Return New Vector2D<T>(GetData())
	End
	
	Method Perpendicular:Vector2D<T>()
		Return (New Vector2D<T>()).AsPerpendicular(-Y, X)
	End
	
	Method AsPerpendicular:Void(V:Vector2D<T>)
		AsPerpendicular(V.X, V.Y)
		
		Return
	End
	
	Method AsPerpendicular:Void()
		AsPerpendicular(-Y, X)
		
		Return
	End
	
	Method AsPerpendicular:Void(X:T, Y:T)
		Self.X = -Y
		Self.Y = X
		
		Return
	End
	
	'#Rem
	Method ReversePerpendicular:Void(V:Vector2D<T>)
		ReversePerpendicular(V.X, V.Y)
		
		Return
	End
	
	Method ReversePerpendicular:Void()
		ReversePerpendicular(X, Y)
		
		Return
	End
	
	Method ReversePerpendicular:Void(X:T, Y:T)
		Self.X = -X
		Self.Y = Y
		
		Return
	End
	'#End
	
	Method Add2D:Vector2D<Float>(V:AbstractVector<T>)
		Local VOut:= (New Vector2D<Float>(Self))
		
		VOut.Add(V)
		
		Return VOut
	End
	
	Method Subtract2D:Vector2D<Float>(V:AbstractVector<T>)
		Local VOut:= (New Vector2D<Float>(Self))
		
		VOut.Subtract(V)
		
		Return VOut
	End
	
	Method Devide2D:Vector2D<Float>(V:AbstractVector<T>)
		Local VOut:= (New Vector2D<Float>(Self))
		
		VOut.Devide(V)
		
		Return VOut
	End
	
	Method Multiply2D:Vector2D<Float>(V:AbstractVector<T>)
		Local VOut:= (New Vector2D<Float>(Self))
		
		VOut.Multiply(V)
		
		Return VOut
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool)
		Local OutStr:String
		
		If (Not GiveName) Then
			OutStr = String(Super.ToString(False) + Comma + Space + "Y:" + Space + SingleQuote + String(GetData(YPOS)) + SingleQuote)
		Else
			OutStr = Name()
		Endif
		
		Return OutStr
	End
	
	' Properties (Public):
	Method G:T() Property
		Return Y()
	End
	
	Method G:Void(Info:T) Property
		Y(Info)
		
		Return
	End
	
	Method Y:T() Property
		Return GetData(YPOS)
	End
	
	Method Y:Void(Info:T) Property
		SetData(YPOS, Info)
		
		Return
	End
	
	Method Right:T() Property
		Return Y()
	End
	
	Method Right:Void(Info:T) Property
		Y(Info)
	End
	
	' Properties (Private):
	Private
	
	' Nothing so far.
	
	Public
	
	' Fields:
	' Nothing so far.
End

Class Vector3D<T> Extends Vector2D<T>
	' Constant variables:
	Const ZPOS:Int = 2
	Const VECTORSIZE:Int = 3

	' Functions:
	Function Name:String()
		Return "Vector(3D)"
	End
	
	Function FromInts:Vector3D<T>(X:Int, Y:Int, Z:Int)
		Return FromFloats(Float(X), Float(Y), Float(Z))
	End
	
	Function FromFloats:Vector3D<T>(X:Float, Y:Float, Z:Float)
		Return New Vector3D(T(X), T(Y), T(Z))
	End
	
	' Constructor(s):
	Method New()
		Super.New(VECTORSIZE)
	End
	
	Method New(Size:Int)
		Super.New(Size)
	End
	
	Method New(Info:T[])
		Super.New(Info)
	End
	
	Method New(V:AbstractVector<T>, Size:Int=VECTORSIZE)
		Super.New(V, Size)
	End
	
	Method New(X:T, Y:T, Z:T=NIL, VECTORSIZE:Int=Vector3D<T>.VECTORSIZE)
		Super.New(X, Y, VECTORSIZE)
		
		Self.Z = Z
	End
	
	' Methods:
	Method Clone:AbstractVector<T>()
		Return New Vector3D<T>(GetData())
	End
	
	Method CrossProduct:Vector3D<T>(V:Vector3D<T>, VOUT:Vector3D<T>=Null)
		If (VOUT = Null) Then VOUT = New Vector3D<T>()
				
		VOUT.X = Y*V.Z - Z*V.Y
		VOUT.Y = Z*V.X - X*V.Z
		VOUT.Z = X*V.Y - Y*V.X
		
		Return VOUT
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool)
		Local OutStr:String
	
		If (Not GiveName) Then
			OutStr = String(Super.ToString(False) + Comma + Space + "Z:" + Space + SingleQuote + String(GetData(ZPOS)) + SingleQuote)
		Else
			OutStr = Name()
		Endif
		
		Return OutStr
	End
	
	' Properties (Public):
	Method B:T() Property
		Return Z()
	End
	
	Method B:Void(Info:T) Property
		Z(Info)
		
		Return
	End
	
	Method Z:T() Property
		Return GetData(ZPOS)
	End
	
	Method Z:Void(Info:T) Property
		SetData(ZPOS, Info)
		
		Return
	End
	
	' Properties (Private):
	Private
	
	' Nothing so far.
	
	Public
	
	' Fields:
	' Nothing so far.
End

Class Vector4D<T> Extends Vector3D<T>
	' Constant variables:
	Const APOS:Int = XPOS
	Const BPOS:Int = YPOS
	Const CPOS:Int = ZPOS
	Const DPOS:Int = 3
	
	Const VECTORSIZE:Int = 4

	' Functions:
	Function Name:String()
		Return "Vector(4D)"
	End
	
	Function FromInts:Vector4D<T>(A:Int, B:Int, C:Int, D:Int)
		Return FromFloats(Float(A), Float(B), Float(C), Float(D))
	End
	
	Function FromFloats:Vector4D<T>(A:Float, B:Float, C:Float, D:Float)
		Return New Vector4D(T(A), T(B), T(C), T(D))
	End
	
	' Constructor(s):
	Method New()
		Super.New(VECTORSIZE)
	End
	
	Method New(Size:Int)
		Super.New(Size)
	End
	
	Method New(Info:T[])
		Super.New(Info)
	End
	
	Method New(V:AbstractVector<T>, Size:Int=VECTORSIZE)
		Super.New(V, Size)
	End
	
	Method New(A:T, B:T, C:T=NIL, D:T=NIL, VECTORSIZE:Int=Vector4D<T>.VECTORSIZE)
		Super.New(A, B, C, VECTORSIZE)
		
		Self.D = D
	End

	' Methods:
	Method Clone:AbstractVector<T>()
		Return New Vector4D<T>(GetData())
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool)
		Local OutStr:String
	
		If (Not GiveName) Then
			OutStr = Super.ToString(False)
		
			OutStr = OutStr.Replace("X", "A")
			OutStr = OutStr.Replace("Y", "B")
			OutStr = OutStr.Replace("Z", "C")
		
			OutStr = (OutStr + Comma + Space + "D:" + Space + SingleQuote + String(GetData(DPOS)) + SingleQuote)
		Else
			OutStr = Name()
		Endif
		
		Return OutStr
	End
	
	' Properties (Public):
	Method A:Void(Info:T) Property
		X(Info)
		
		Return
	End
	
	Method B:Void(Info:T) Property
		Y(Info)
		
		Return
	End
	
	Method C:Void(Info:T) Property
		Z(Info)
		
		Return
	End
	
	Method W:Void(Info:T) Property
		SetData(DPOS, Info)
		
		Return
	End
	
	Method D:Void(Info:T) Property
		W(Info)
		
		Return
	End
	
	Method A:T() Property
		Return X
	End
	
	Method B:T() Property
		Return Y
	End
	
	Method C:T() Property
		Return Z
	End
	
	Method W:T() Property
		Return GetData(DPOS)
	End
	
	Method D:T() Property
		Return W
	End
	
	' Properties (Private):
	Private
	
	' Nothing so far.
	
	Public
	
	' Fields:
	' Nothing so far.
End

Class ManualVector<T> Extends Vector4D<T>
	' Constant variables:
	Const VECTORSIZE:Int = 5
	
	' Functions:
	Function Name:String()
		Return "Vector"
	End

	' Constructor(s):
	Method New()
		Super.New(VECTORSIZE)
	End
	
	Method New(Info:T[])
		Super.New(Info)
	End
	
	Method New(V:AbstractVector<T>, Size:Int=AUTO)
		Super.New(V, Size)
	End
	
	#Rem
	Method New()
		'Error("The 'ManualVector' class can't be created without parameters.")
		
		Data = New T[VECTORSIZE]
	End
	#End
	
	Method New(Size:Int)
		Data = New T[Size]
	End
	
	' Methods:
	Method Clone:AbstractVector<T>()
		Return New ManualVector<T>(GetData())
	End
	
	Method Index:T[]()
		Return GetData()
	End
	
	Method Index:T(I:Int)
		Return GetData(I)
	End
	
	Method Resize:Bool(Size:Int)
		Self.Data = Data.Resize(Size)
	
		' Return the default response.
		Return True
	End
	
	Method Resize:Bool()
		Self.Data = Data.Resize(Size+1)
	
		Return True
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool)
		Local OutStr:String = "Null"
	
		If (Not GiveName) Then
			Select Size()
				Case 1
					' Abstract/1D Vector.
					If (AbstractVector<T>(Self) <> Null) Then
						OutStr = AbstractVector<T>(Self).ToString(False)
					Endif
				Case 2
					' 2D Vector.
					If (Vector2D<T>(Self) <> Null) Then
						OutStr = Vector2D<T>(Self).ToString(False)
					Endif
				Case 3
					' 3D Vector.
					If (Vector3D<T>(Self) <> Null) Then
						OutStr = Vector3D<T>(Self).ToString(False)
					Endif
				Case 4
					' 4D Vector.
					If (Vector4D<T>(Self) <> Null) Then
						OutStr = Vector4D<T>(Self).ToString(False) ' Super.ToString(False)
					Endif
				Default
					' Reset the output string.
					OutStr = ""
				
					For Local Index:Int = 0 Until Size()
						OutStr += String("Index[" + String(Index) + "]: " + SingleQuote + String(GetData(Index)) + SingleQuote)
						
						If (Index < (SizeAUTO)) Then
							OutStr += (Comma + Space)
						Endif
					Next
					
					If (OutStr.Find(SingleQuote+SingleQuote)) Then
						OutStr = OutStr.Replace(SingleQuote + SingleQuote, SingleQuote + "Null" + SingleQuote)
					Endif
			End
		Else
			OutStr = Name()
		Endif
		
		Return OutStr
	End
	
	' Properties (Public):
	#Rem
	Method Size:Void(S:Int) Property
		Resize(S)
		
		Return
	End
	#End
	
	Method NewSize:Void(S:Int) Property
		Resize(S)
		
		Return
	End
	
	Method SetSize:Void(S:Int) Property
		Resize(S)
		'NewSize(S)
	
		Return
	End
	
	Method A:Void(Info:T) Property
		If (Data.Length() > APOS) Then
			Super.A(Info)
		Endif
		
		Return
	End
	
	Method B:Void(Info:T) Property
		If (Data.Length() > BPOS) Then
			Super.B(Info)
		Endif
		
		Return
	End
	
	Method C:Void(Info:T) Property
		If (Data.Length() > CPOS) Then
			Super.C(Info)
		Endif
		
		Return
	End
	
	Method D:Void(Info:T) Property
		If (Data.Length() > DPOS) Then
			Super.D(Info)
		Endif
		
		Return
	End
	
	' Properties (Private):
	Private
	
	' Nothing so far.
	
	Public
	
	' Fields:
	' Nothing so far.
End

' Functions:
Function DotProductNormalized:Float(V1:AbstractVector<Float>, V2:AbstractVector<Float>)
	Return AbstractVector<Float>.DotProductNormalized(V1, V2)
End