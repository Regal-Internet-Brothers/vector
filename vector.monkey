Strict

Public

#Rem
	TODO:
		* Change several uses of "Data.Length()" to use the 'Size' property.
		* Remove the limitation of not being able to offset the internal-data of the active vector properly. (Horribly complicated)
		
	COMMAND NAMING CONVENTIONS:
		* The names of commands (Methods, functions, etc) usually indicate the return value of said command.
		
		For example, most commands ending with an underscore ("_"), then the class's "dimension tag" ("2D", "3D", etc) will likely not return a vector object.
		Whereas a command which does not have an underscore as a seperator will very likely return a vector of some kind (Generated, usually).
		
		See commands like the 'Vector2D' class's 'Add2D', and the 'Vector3D' class's 'Rotate_3D' as examples.
		
		* Most methods (Unless explicitly stated otherwise) will affect the vector their used from.
		
		For example, the 'Add' command found in the 'AbstractVector' class does not produce a vector of any kind.
		This command only affects its own object's ('Self') data, meaning it will mutate based on the input.
		
		However, it will likely not mutate the input itself.
		
	GENERAL ARGUMENT NOTES:
		* When reading the arguments of some of these commands, you'll find some common names.
		
		Here's a few, and what they tend to mean:
		
		* VData_Length: The length of the current vector's data container.
		
		* VData_Offset: The offset used when accessing the current vector.
		This does not change 'VData_Length' as the end-point, so you can set this to anything and not have an issue.
		
		* A_Length: The length of the current (Usually external) array.
		* A_Offset: The offset used when accessing the current (Usually external) array.
	
	OTHER NOTES:
		* When dealing with lengths and offsets in this module, it's best to understand what they actually mean.
		Basically, most situations which allow manual input for offsets and/or lengths work with a 'For' loop internally.
		This loop (Conceptually) starts at the offset, and ends at the specified length (If there is any) / the internal length of the array at hand.
		
		You SHOULD NOT expect the offset to change what the length is in any way, shape, or form. The length of an array is treated as the end point.
		To put it simply, the loop has what I tend to call an operation area. I define an operation area like so: Operation_Area = (Length-Offset).
		
		The loop will (As far as the user is concerned) start at your defined offset, and end at the length specified.
		
		Commands technically have the right to disregard these notes, but they will usually have notation specifying such.
		
		* For the sake of future-proofing, all 'For' loops with in-line local variables which are directly
		used to iterate through memory will be done with dynamic type-detection via the ':=' operator.
		
		* THESE RULES DO NOT APPLY TO ALL MODULES I RELEASE, BUT THEY DEFINITELY APPLY HERE.
#End

' Preprocessor related:
#VECTOR_GROW_ON_ACCESS = True
#VECTOR_ALLOW_EXACT_GROWTH = True
#VECTOR_SMART_GROW = True
#VECTOR_TOSTRING_USE_GENERIC_UTIL = False ' True

#If CONFIG = "release"
	#VECTOR_ALTERNATE_DIVISION = True
#Else
	#VECTOR_ALTERNATE_DIVISION = False
#End

#If CONFIG = "debug"
	#VECTOR_SAFETY = True
	#VECTOR_NUMBER_SAFETY = True
#Else
	#VECTOR_SAFETY = True ' False
	#VECTOR_NUMBER_SAFETY = False
#End

#VECTOR_ALTERNATE_NEGATE = False ' True

' Imports:

' BRL:
Import brl.stream

' ImmutableOctet:
Import util
Import ioelement

' Global variable(s):
' Nothing so far.

' Constant variable(s):
Const VECTOR_AUTO:= UTIL_AUTO

' Property data-positions:
Const VECTOR_XPOSITION:= 0
Const VECTOR_YPOSITION:= 1
Const VECTOR_ZPOSITION:= 2

' Interfaces:
Interface Vector<T>
	' Constant variable(s):
	Const XPOS:= VECTOR_XPOSITION
	Const YPOS:= VECTOR_YPOSITION
	Const ZPOS:= VECTOR_ZPOSITION
	
	Const AUTO:= VECTOR_AUTO
	
	Const ZERO:= T(0)
	Const ONE:= T(1)
	Const TWO:= T(2)
	
	Const FULL_ROTATION_IN_DEGREES:= T(360)
	Const HALF_FULL_ROTATION_IN_DEGREES:= FULL_ROTATION_IN_DEGREES / TWO
	
	' Methods (Public):
	
	' Conversion commands:
	Method ToString:String()
	Method ToString:String(GiveName:Bool, FixErrors:Bool=True)
	
	' General purpose commands:
	Method Clone:Vector<T>()
	
	Method Copy:Void(V:Vector<T>, FitVector:Bool)
	Method Copy:Void(V:Vector<T>, Size:Int=AUTO, Offset:Int=XPOS, FitVector:Bool=False)
	
	Method Copy:Void(Info:T[], FitInfo:Bool)
	Method Copy:Void(Info:T[], Size:Int=AUTO, Offset:Int=XPOS, FitInfo:Bool=False)
	
	Method GetData:T(Index:Int)
	Method GetData:T[]()
	
	Method SetData:Void(Index:Int, Info:T)
	
	' Mathematical commands:
	Method Zero:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method Absolute:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Negate:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method ForceNegative:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method ApplyMin:Void(Value:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method ApplyMax:Void(Value:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method ApplyClamp:Void(MinValue:T, MaxValue:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method Add:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method Add:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Add:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method DeltaAdd:Void(V:Vector<T>, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method DeltaAdd:Void(A:T[], Scalar:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method DeltaAdd:Void(F:T, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method Decelerate:Void(Deceleration:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Accelerate:Void(V:Vector<T>, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method Subtract:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Subtract:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method Subtract:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method Divide:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Divide:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method Divide:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method Multiply:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Multiply:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method Multiply:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method LinearInterpolation:Void(V:Vector<T>, t:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method LinearInterpolation:Void(A:T[], t:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
	
	Method Normalize:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Normalize:Void(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method IsNormalTo:Bool(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method IsNormalTo:Bool(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	
	Method IsEqualTo:Bool(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method IsEqualTo:Bool(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	
	Method Distance:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Distance:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	
	Method DotProduct:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method DotProduct:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method DotProductNormalized:T(V:Vector<T>)
	
	Method SubtractTowardsZero:Void(Time:T=ONE, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method ProjectionScalar:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method ProjectionScalar:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method Project:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Project:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	' This is basically the same as 'Multiply'.
	Method Project:Void(Scalar:T)
	
	Method MakeBetween:Vector<T>(V:Vector<T>)
	
	Method AngleBetween:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method AngleBetween:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method AngleBetweenCos:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method AngleBetweenCos:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method AngleBetweenSin:T(V:Vector2D<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method AngleBetweenSin:T(A:T[], TempVector:Vector<T>)
	Method AngleBetweenSin:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, TempVector:Vector<T>=Null)
	
	Method LengthScalar:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method LengthScalar:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method Normalized:Vector<T>(VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
	Method Normalized:Vector<T>(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
	
	' This does not have to be legitimately implemented.
	' Even if you were to implement it, it's not going to be efficient.
	Method CrossProduct:Vector<T>(V:Vector<T>, VOUT:Vector<T>=Null)
	
	' Methods (Private):
	Private
	
	Method Resize:Bool()
	Method Resize:Bool(Size:Int)
	
	Method Grow:Bool(GrowthIndex:Int=AUTO)
	Method ControlledGrow:Bool(Index:Int=AUTO)
	
	Public
	
	' Properties (Public):
	Method Size:Int() Property
	
	Method Length:T(VData_Length:Int=AUTO, VData_Offset:Int=XPOS) Property
	Method Length:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS) Property
	Method Length:Void(Value:T) Property
	
	Method X:T() Property
	Method X:Void(Info:T) Property
	
	' Properties (Private):
	Private
	
	Method Data:T[]() Property
	
	Public
End

' Classes:
Class AbstractVector<T> Implements Vector<T>, SerializableElement ' Abstract
	' Constant variables:
	
	' The position of the 'X' property.
	Const XPOS:= Vector<T>.XPOS
	
	' The size of this vector-type.
	Const VECTORSIZE:Int = 1
	
	' General:
	Const AUTO:= VECTOR_AUTO
	
	' Number constants:
	Const ZERO:= Vector<T>.ZERO
	Const ONE:= Vector<T>.ONE
	Const TWO:= Vector<T>.TWO
	
	Const FULL_ROTATION_IN_DEGREES:= Vector<T>.FULL_ROTATION_IN_DEGREES
	Const HALF_FULL_ROTATION_IN_DEGREES:= Vector<T>.HALF_FULL_ROTATION_IN_DEGREES
	
	' Error template(s):
	Const VECTOR_GENERIC_ERROR_TEMPLATE:String = "{VECTOR} {ERROR}: "
	
	' Defaults:
	Const Default_ExactGrowthThreshold:Int = 16
	
	' Boleans / Flags:
	Const Default_ToString_FixErrors:Bool = True
	
	' Global variables:
	
	' The default value of the type specified.
	Global NIL:T
	
	' The name of this class.
	Global Name_Str:String = "Vector (Abstract)"
	
	' Defaults:
	
	' The default multiplier used for container growth.
	Global Default_GrowthMultiplier:Float = 1.5 ' 2.0
	
	' Booleans / Flags:
	
	' This represents the default auto-grow flag for all vector classes for the current type ('T').
	Global Default_AutoGrow:Bool = False
	
	' Functions:
	Function Name:String()
		Return Name_Str
	End
	
	Function DotProductNormalized:T(V1:Vector<T>, V2:Vector<T>)
		Return V1.DotProductNormalized(V2)
	End
	
	Function VectorError:Void(Message:String, Template:String=VECTOR_GENERIC_ERROR_TEMPLATE)
		DebugError(Template+Message)
		
		Return
	End

	' Constructor(s) (Public):
	Method New(Size:Int)
		CreateData(Size)
	End
	
	Method New(Info:T[], CopyInfo:Bool)
		If (CopyInfo) Then
			Assign(Info)
		Else
			AssignByRef(Info)
		Endif
	End
	
	Method New(Info:T[], Size:Int=AUTO, Offset:Int=XPOS)
		Assign(Info, Size, Offset)
	End
	
	Method New(V:Vector<T>, Size:Int=AUTO, Offset:Int=XPOS)
		' Local variable(s):
		Local FitVector:Bool = False
		
		' Check if the size was specified:
		If (Size = AUTO) Then
			Size = V.Size
			
			FitVector = True
		Endif
		
		' Create and manage the internal container:
		CreateData(Size)
		
		' Copy the internal data of 'V'.
		Assign(V, Size, Offset, FitVector)
	End
	
	' Constructor(s) (Private):
	Private
	
	Method CreateData:Void(Size:Int)
		Data = New T[Size]
		
		Return
	End
	
	Public

	' Methods:
	Method Clone:Vector<T>()
		Return CloneAsAbstract()
	End
	
	Method CloneAsAbstract:AbstractVector<T>()
		Return New AbstractVector<T>(GetData())
	End
	
	Method Clone:Void(V:Vector<T>, FitVector:Bool)
		Assign(V, FitVector)
		
		Return
	End
	
	Method Clone:Void(V:Vector<T>, Size:Int=AUTO, Offset:Int=XPOS, FitVector:Bool=False)
		Assign(V, Size, Offset, FitVector)
		
		Return
	End
	
	Method Copy:Void(V:Vector<T>, FitVector:Bool)
		Clone(V, FitVector)
		
		Return
	End
	
	Method Copy:Void(V:Vector<T>, Size:Int=AUTO, Offset:Int=XPOS, FitVector:Bool=False)
		Clone(V, Size, Offset, FitVector)
		
		Return
	End
	
	Method Copy:Void(Info:T[], FitInfo:Bool)
		Copy(Info, AUTO, XPOS, FitInfo)
		
		Return
	End
	
	Method Copy:Void(Info:T[], Size:Int=AUTO, Offset:Int=XPOS, FitInfo:Bool=False)
		Assign(Info, Size, Offset, FitInfo)
		
		Return
	End
	
	Method Assign:Void(V:Vector<T>, FitVector:Bool)
		Assign(V, AUTO, XPOS, FitVector)
		
		Return
	End
	
	Method Assign:Void(V:Vector<T>, Size:Int=AUTO, Offset:Int=XPOS, FitVector:Bool=False)
		' Check for errors:
		#If VECTOR_SAFETY
			If (V = Null) Then Return
		#End
		
		Assign(V.Data, Size, Offset, FitVector)
	
		Return
	End
	
	Method Assign:Void(Info:T[], FitInfo:Bool)
		Assign(Info, AUTO, XPOS, FitInfo)
		
		Return
	End
	
	Method Assign:Void(Info:T[], Size:Int=AUTO, Offset:Int=XPOS, FitInfo:Bool=True)
		If (Size = AUTO) Then
			Size = Info.Length()
		Endif
		
		'Self.Data = GenericUtilities<T>.CopyArray(Info, Self.Data, FitInfo)
		Self.Data = GenericUtilities<T>.CopyArray(Info, Self.Data, Offset, XPOS, Size, AUTO, FitInfo)
		
		'AssignByRef(Info.Resize(Size))
		
		Return
	End
	
	Method AssignByRef:Void(Info:T[])
		Self.Data = Info
		
		Return
	End
	
	Method GetData:T(Index:Int)
		#If VECTOR_SAFETY
			If (Index >= Size) Then
				#If VECTOR_GROW_ON_ACCESS
					If (AutoGrow) Then
						ControlledGrow(Index)
					Else
				#End
						#If CONFIG = "debug"
							VectorError("Attempted to access an invalid or non-existent element.")
						#End
					
						Return NIL
				#If VECTOR_GROW_ON_ACCESS
					Endif
				#End
			Endif
			
			If (Index < XPOS) Then
				#If CONFIG = "debug"
					VectorError("Attempted to access protected memory.")
				#End
				
				Return NIL
			Endif
		#End
		
		Return Self.Data[Index]
	End
	
	Method GetData:T[]()
		Return Data
	End
	
	Method SetData:Void(Index:Int, Info:T)
		If (AutoGrow) Then
			ControlledGrow(Index)
		Endif
		
		#If VECTOR_SAFETY
			#If CONFIG = "debug"
				If (Index >= Size) Then
					DebugStop()
				Endif
			#End
		#End
		
		Self.Data[Index] = Info		
		
		Return
	End
	
	Method Resize:Bool(Size:Int)
		Self.Data = Data.Resize(Size)
	
		' Return the default response.
		Return True
	End
	
	Method Resize:Bool()
		Self.Data = Self.Data.Resize(Size * GrowthMultiplier)
		
		' Return the default response.
		Return True
	End
	
	' This command accepts an index, not a size.
	Method Grow:Bool(GrowthIndex:Int=AUTO)
		If (GrowthIndex = AUTO) Then
			Return Resize()
		Endif
		
		#If VECTOR_SAFETY
			If (GrowthIndex < Size) Then
				Return False
			Endif
		#End
		
		Local Growth:Int = (GrowthIndex-(LastIndex))
		
		' If we're allowed to do so, resize exactly:
		#If VECTOR_ALLOW_EXACT_GROWTH
			If (Growth >= ExactGrowthThreshold) Then
				Return Resize(GrowthIndex+1)
			Endif
		#End
		
		' If we get to this point, simply use standard resizing.
		Return Resize()
	End
	
	Method ControlledGrow:Bool(Index:Int=AUTO)
		' Local variable(s):
		Local Size:= Self.Size
		
		' Check for errors:
		#If VECTOR_SAFETY
			If (Index <> AUTO And Index < Size) Then
				Return False
			Endif
		#End
		
		#If VECTOR_SMART_GROW
			' If we were using a different memory model, this would work well:
			#Rem
				Local Response:Bool = False
				
				' Continue growing until the internal container is big enough:
				Repeat
					Response = Grow()
					
					' Make sure we were able to grow:
					If (Not Response) Then
						' We weren't able to grow, return a negative response.
						Return False
					Endif
				Until (Size > Index)
			#End
			
			' Grow to the desired size.
			Return Grow(Index)
		#Else
			If (Index = AUTO) Then
				Return Resize(Size+1)
			Endif
			
			Return Resize(Index+1)
		#End
	End
	
	Method Zero:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Data[I] = NIL ' ZERO
		Next
		
		Return
	End
	
	Method Absolute:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Data[I] = Abs(Data[I])
		Next
		
		Return
	End
	
	Method Negate:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If Not VECTOR_ALTERNATE_NEGATE
				Data[I] = -Data[I]
			#Else
				Data[I] *= -1
			#End
		Next
		
		Return
	End
	
	Method ForceNegative:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Absolute(VData_Length, VData_Offset)
		Negate(VData_Length, VData_Offset)
		
		Return
	End
	
	Method ApplyMin:Void(Value:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Self.Data[I] = Min(Self.Data[I], Value)
		Next
		
		Return
	End
	
	Method ApplyMax:Void(Value:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Self.Data[I] = Max(Self.Data[I], Value)
		Next
		
		Return
	End
	
	Method ApplyClamp:Void(MinValue:T, MaxValue:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Self.Data[I] = Clamp(Self.Data[I], MinValue, MaxValue)
		Next
		
		Return
	End
	
	' Add the input-vector to this vector:
	Method Add:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Add(V.Data, VData_Length, VData_Offset)
		
		Return
	End
	
	Method Add:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			Data[Index] += A[Index]
		Next
		
		Return
	End
	
	' This overload adds by scalar, instead of by vector.
	Method Add:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Data[Index] += F
		Next
		
		Return
	End
	
	Method DeltaAdd:Void(V:Vector<T>, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		DeltaAdd(V.Data, Scalar, VData_Length, VData_Offset)
		
		Return
	End
	
	Method DeltaAdd:Void(A:T[], Scalar:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			Data[Index] += A[Index] * Scalar
		Next
		
		Return
	End
	
	Method DeltaAdd:Void(F:T, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Data[Index] += F * Scalar
		Next
		
		Return
	End
	
	Method Decelerate:Void(Deceleration:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		Local VelocityLength:= Length()
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			If (Data[Index] > 0.0) Then
				Data[Index] = Max(Data[Index]-(((Data[Index] / VelocityLength)*Deceleration)), 0.0)
			Else
				Data[Index] = Min(Data[Index]-(((Data[Index] / VelocityLength)*Deceleration)), 0.0)
			Endif
		Next
		
		Return
	End
	
	Method Accelerate:Void(V:Vector<T>, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		DeltaAdd(V, Scalar, VData_Length, VData_Offset)
		
		Return
	End
	
	' Subtract the input-vector from this vector:
	Method Subtract:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Subtract(V.Data, VData_Length, VData_Offset)
		
		Return
	End
	
	Method Subtract:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			Data[Index] -= A[Index]
		Next
		
		Return
	End
	
	' Subtract by scalar, instead of by vector.
	Method Subtract:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Data[Index] -= F
		Next
		
		Return
	End
	
	Method Divide:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Divide(V.Data, VData_Length, VData_Offset)
		
		Return
	End
	
	Method Divide:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			#If Not VECTOR_ALTERNATE_DIVISION
				Data[Index] /= A[Index]
			#Else
				' Local variable(s):
				Local A_On_Index:= A[Index]
				
				#If VECTOR_NUMBER_SAFETY
					If (A_On_Index <> NIL) Then
				#End
						Data[Index] *= (ONE/A_On_Index)
				#If VECTOR_NUMBER_SAFETY
					Else
						Data[Index] = NIL
					Endif
				#End
			#End
		Next
		
		Return
	End
	
	Method Divide:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		#If VECTOR_ALTERNATE_DIVISION
			#If VECTOR_NUMBER_SAFETY
				If (F <> NIL) Then
			#End
					Multiply(ONE/F, VData_Length, VData_Offset)
			#If VECTOR_NUMBER_SAFETY
				Else
					Zero(VData_Length, VData_Offset)
				Endif
			#End
		#Else
			' Local variable(s):
			Local VData_RawLength:= Data.Length()
			
			If (VData_Length = AUTO) Then
				VData_Length = VData_RawLength
			Endif
			
			For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
				Data[Index] /= F
			Next
		#End
		
		Return
	End
	
	Method Multiply:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Multiply(V.Data, VData_Length, VData_Offset)
		
		Return
	End
	
	Method Multiply:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			Data[Index] *= A[Index]
		Next
		
		Return
	End
	
	Method Multiply:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Data[Index] *= F
		Next
		
		Return
	End
	
	Method LinearInterpolation:Void(V:Vector<T>, t:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		LinearInterpolation(V.Data, t, VData_Length, VData_Offset)
		
		Return
	End
	
	Method LinearInterpolation:Void(A:T[], t:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		#If VECTOR_NUMBER_SAFETY
			t = Clamp(t, ZERO, ONE)
		#End
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			Data[Index] = Data[Index] + (A[Index]-Data[Index]) * t
		Next
		
		Return
	End
	
	Method Normalize:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Normalize(Length(), VData_Length, VData_Offset)
		
		Return
	End
	
	Method Normalize:Void(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		If (Length <> NIL) Then
			Divide(Length, VData_Length, VData_Offset)
		Endif
		
		Return
	End
	
	Method IsNormalTo:Bool(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return IsNormalTo(V.Data, VData_Length, VData_Offset)
	End
	
	Method IsNormalTo:Bool(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		Return (DotProduct(A, A_Length, A_Offset) = ZERO)
	End
	
	Method IsEqualTo:Bool(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return IsEqualTo(V.Data, VData_Length, VData_Offset)
	End
	
	Method IsEqualTo:Bool(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			' Check if the two elements are equal:
			If (A[Index] <> Data[Index]) Then
				' The elements are not equal, return a negative response.
				Return False
			Endif
		End
		
		' Return the default response.
		Return True
	End
	
	Method Distance:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return Distance(V.Data, VData_Length, VData_Offset)
	End
	
	Method Distance:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local D:T = ZERO
		
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			D += Pow(A[Index]-Data[Index], TWO)
		Next
		
		Return Sqrt(D)
	End
	
	Method DotProduct:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return DotProduct(V.Data, VData_Length, VData_Offset)
	End
	
	Method DotProduct:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		Local Sum:T = NIL
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			Sum += Data[Index]*A[Index]
		Next
		
		Return Sum
	End
	
	Method DotProductNormalized:T(V:Vector<T>)
		Return DotProductNormalized(V, Null, Null)
	End
	
	#Rem
		ARGUMENT NOTES:
			* The 'FTV' and 'STV' arguments stand for "First Temporary Vector" and "Second Temporary Vector".
			Effectively, if you send in one or both vectors, the data of 'V' and this object will be copied to them.
			
			So, if you don't want an object to be generated, you should give this pre-allocated vectors of some kind.
	
			Those temporary vectors should be either able to be resized which needed (The standard implementations here do this),
			or they'll need to be the same sizes as the associated vectors.
			
			* The 'V_Length' and 'V_Offset' arguments are referring to the 'V' argument.
			* The 'VData_Length' and 'VData_Offset' arguments are referring to the current vector (Self).
	#End
	
	Method DotProductNormalized:T(V:Vector<T>, FTV:Vector<T>, STV:Vector<T>, V_Length:Int=AUTO, V_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		If (V_Length = AUTO) Then
			V_Length = V.Size
		Endif
		
		' Local variable(s):
		Local Size:= Self.Size
		
		Local STV_Length:= Min(V_Length, Size)
		Local STV_Offset:= Min(V_Offset, Size)
		
		If (FTV = Null) Then
			FTV = New AbstractVector<T>(Self, VData_Length, VData_Offset)
		Else
			FTV.Copy(Self, VData_Length, VData_Offset)
		Endif
		
		If (STV = Null) Then
			STV = New AbstractVector<T>(V, STV_Length, STV_Offset)
		Else
			STV.Copy(V, STV_Length, STV_Offset)
		Endif
		
		FTV.Normalize(VData_Length, VData_Offset)
		STV.Normalize()
		
		' Return the calculated result.
		Return FTV.DotProduct(STV)
	End
	
	Method SubtractTowardsZero:Void(Time:T=ONE, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		' Ensure we have a valid delta.
		#If VECTOR_NUMBER_SAFETY
			Time = Clamp(Time, ZERO, ONE)
		#End
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			If (Data[I] > ZERO) Then
				Data[I] = Max(Data[I]-(Data[I]*Time), ZERO)
			Else
				Data[I] = Min(Data[I]-(Data[I]*Time), ZERO)
			Endif
		Next
		
		Return
	End
	
	Method ProjectionScalar:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return ProjectionScalar(V.Data, VData_Length, VData_Offset)
	End
	
	Method ProjectionScalar:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return (DotProduct(A, A_Length, A_Offset) / LengthScalar(A, A_Length, A_Offset, VData_Length, VData_Offset))
	End
	
	Method Project:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Project(ProjectionScalar(V, VData_Length, VData_Offset))
		
		Return
	End
	
	Method Project:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Project(ProjectionScalar(A, A_Length, A_Offset, VData_Length, VData_Offset))
		
		Return
	End
	
	Method Project:Void(Scalar:T)
		Multiply(Scalar)
		
		Return
	End
	
	Method MakeBetween:Vector<T>(V:Vector<T>)
		' Local variable(s):
		
		' Generate a new vector.
		Local VOUT:= Clone()
		
		VOUT.Subtract(V)
		
		' Return the output-vector.
		Return VOUT
	End
	
	Method AngleBetween:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return AngleBetween(V.Data, VData_Length, VData_Offset)
	End
	
	Method AngleBetween:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return ACos(AngleBetweenCos(A, A_Length, A_Offset, VData_Length, VData_Offset))
	End
	
	Method AngleBetweenCos:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return AngleBetweenCos(V.Data, VData_Length, VData_Offset)
	End
	
	Method AngleBetweenCos:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return AngleBetween_TransformProduct(DotProduct(A, A_Length, A_Offset), A, A_Length, A_Offset, VData_Length, VData_Offset)
	End
	
	Method AngleBetweenSin:T(V:Vector2D<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return AngleBetween_TransformProduct(CrossProduct(V).X, V.Data, AUTO, XPOS, VData_Length, VData_Offset)
	End
	
	Method AngleBetweenSin:T(A:T[], TempVector:Vector<T>)
		Return AngleBetweenSin(A, AUTO, XPOS, AUTO, XPOS, TempVector)
	End
	
	Method AngleBetweenSin:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, TempVector:Vector<T>=Null)
		If (TempVector = Null) Then
			TempVector = New AbstractVector(A, A_Length, A_Offset)
		Else
			TempVector.Copy(A, A_Length, A_Offset)
		Endif
		
		Return AngleBetween_TransformProduct(CrossProduct(TempVector).X, A, A_Length, A_Offset, VData_Length, VData_Offset)
	End
	
	Method AngleBetween_TransformProduct:T(Product:T, A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return (Product / LengthScalar(A, A_Length, A_Offset, VData_Length, VData_Offset))
	End
	
	Method LengthScalar:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return LengthScalar(V, VData_Length, VData_Offset)
	End
	
	Method LengthScalar:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return (Length(VData_Length, VData_Offset) * Length(A, A_Length, A_Offset))
	End
	
	Method Normalized:Vector<T>(VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
		Return Normalized(Length(VData_Length, VData_Offset), VData_Length, VData_Offset, OutputVector)
	End
	
	Method Normalized:Vector<T>(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
		If (OutputVector = Null) Then
			OutputVector = Clone()
		Else
			OutputVector.Copy(Self, VData_Length, VData_Offset)
		Endif
		
		' Normalize the targeted vector.
		OutputVector.Normalize(Length, VData_Length, VData_Offset)
		
		' Return the output-vector.
		Return OutputVector
	End
	
	Method CrossProduct:Vector<T>(V:Vector<T>, VOUT:Vector<T>=Null)
		Return Null
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool, FixErrors:Bool=Default_ToString_FixErrors)
		If (Not GiveName) Then
			Return "X:" + Space + SingleQuote + String(GetData(XPOS)) + SingleQuote
		Endif
		
		Return Name()
	End
	
	Method Load:Bool(S:Stream)
		Return Read(S)
	End
	
	Method Save:Bool(S:Stream)
		Return Write(S)
	End
	
	Method Read:Bool(S:Stream, ReadSize:Int=0)
		' Check for errors:
		#If VECTOR_SAFETY
			If (S = Null Or S.Eof()) Then
				Return False
			Endif
		#End
		
		If (ReadSize = 0) Then
			ReadSize = Self.Data.Length()
		Endif
		
		GenericUtilities<T>.Read(S, Self.Data, ReadSize)
		
		' Return the default response.
		Return True
	End
	
	Method Write:Bool(S:Stream, WriteSize:Bool=False)
		' Check for errors:
		#If VECTOR_SAFETY
			If (S = Null) Then
				Return False
			Endif
		#End
		
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
	
	Method Length:T(VData_Length:Int=AUTO, VData_Offset:Int=XPOS) Property
		Return Length(Self.Data, VData_Length, VData_Offset)
	End
	
	Method Length:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS) Property
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		Local Sum:T = NIL
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			Sum += A[Index]*A[Index] ' Pow(A[Index], TWO)
		Next
		
		Return Sqrt(Sum)
	End
	
	Method Length:Void(Value:T) Property
		' Local variable(s):
		Local Length:= Self.Length
		
		If (Value = NIL) Then
			Zero()
			
			Return
		Endif
		
		If (Length > ZERO) Then
			Multiply(Value / Length)
		Else
			Zero()
			
			X = Value
		Endif
		
		Return
	End
	
	Method Size:Int() Property
		Return Data.Length()
	End
	
	Method Size:Void(Input:Int) Property
		If (AutoGrow) Then
			ControlledGrow(Input+1)
		Endif
		
		Return
	End
	
	Method LastIndex:Int() Property
		Return Size-1
	End
	
	Method GrowthMultiplier:Float() Property
		Return Default_GrowthMultiplier
	End
	
	Method AutoGrow:Bool() Property
		Return Self._AutoGrow
	End
	
	Method ExactGrowthThreshold:Int() Property
		Return Default_ExactGrowthThreshold
	End
	
	Method ExactGrowthThreshold:Void(Input:Int) Property
		' Nothing so far.
		
		Return
	End
	
	' Properties (Private):
	Private
	
	Method Data:T[]() Property
		Return Self._Data
	End
	
	Method Data:Void(Input:T[]) Property
		Self._Data = Input
		
		Return
	End
	
	Method AutoGrow:Void(Input:Bool) Property
		Self._AutoGrow = Input
		
		Return
	End
	
	Public
	
	' Fields (Public):
	' Nothing so far.
	
	' Fields (Private):
	Private
	
	' The internal data container.
	Field _Data:T[]
	
	' Booleans / Flags:
	
	' I'm not the biggest fan of this, but...
	Field _AutoGrow:Bool = Default_AutoGrow
	
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
	
	Method ToString:String(GiveName:Bool, FixErrors:Bool=Default_ToString_FixErrors)
		If (Not GiveName) Then
			Return "Value: " + String(Value())
		Endif
		
		Return Name()
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
	Const YPOS:= Vector<T>.YPOS
	Const VECTORSIZE:Int = 2
	
	' Global variable(s):
	
	' The name of this class.
	Global Name_Str:String = "Vector(2D)"

	' Functions:
	Function Name:String()
		Return Name_Str
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
		
	Method New(Info:T[], CopyInfo:Bool)
		Super.New(Info, CopyInfo)
	End
	
	Method New(Info:T[], Size:Int=VECTORSIZE, Offset:Int=XPOS)
		Super.New(Info, Size, Offset)
	End
	
	Method New(V:Vector<T>, Size:Int=VECTORSIZE, Offset:Int=XPOS)
		Super.New(V, Size, Offset)
	End
	
	Method New(X:T, Y:T, VECTORSIZE:Int=Vector2D<T>.VECTORSIZE)
		Super.New(VECTORSIZE)
		
		Self.X = X
		Self.Y = Y
	End
		
	' Methods (Public):	
	Method Clone:Vector<T>()
		Return CloneAs2D()
	End
	
	Method CloneAs2D:Vector2D<T>()
		Return New Vector2D<T>(GetData())
	End
	
	Method CrossProduct:Vector<T>(V:Vector<T>, VOUT:Vector<T>=Null)
		' Local variable(s):
		Local V2D:= Vector2D<T>(V)
		Local V2DOut:Vector2D<T>
		
		#If VECTOR_SAFETY
			If (V2D = Null) Then
				Return Null
			Endif
		#End
		
		#If VECTOR_SAFETY
			If (VOUT <> Null) Then
		#End
				V2DOut = Vector2D<T>(VOUT)
				
				#If VECTOR_SAFETY
					If (V2DOut = Null) Then
						Return Null
					Endif
				#End
		#If VECTOR_SAFETY
			Endif
		#End
		
		' Call the main implementation.
		Return CrossProduct2D(V2D, V2DOut)
	End
	
	Method CrossProduct2D:Vector2D<T>(V:Vector2D<T>, VOUT:Vector2D<T>=Null)
		If (VOUT = Null) Then
			VOUT = New Vector2D<T>(Self)
		Else
			VOUT.Copy(Self)
		Endif
		
		' Local variable(s):
		VOUT.X = VOUT.CrossProduct_2D(V)
		
		Return VOUT
	End
	
	Method CrossProduct_2D:T(V:Vector2D<T>, VData_Offset:Int=XPOS)
		Return CrossProduct_2D(V.Data, VData_Offset)
	End
	
	Method CrossProduct_2D:T(A:T[], A_Offset:Int=XPOS)
		' Local variable(s):
		Local REAL_X:= XPOS+A_Offset
		Local REAL_Y:= YPOS+A_Offset
		
		#If VECTOR_SAFETY
			If (OutOfBounds(Max(REAL_X, REAL_Y), A.Length())) Then
				Return NIL
			Endif
		#End
		
		Return (X*A[REAL_Y] - Y*A[REAL_X])
	End
	
	Method RotateTowards:Void(V:Vector2D<T>)
		Rotate(CrossProduct_2D(V))
		
		Return
	End
	
	Method Rotate:Void(Angle:T)
		' Local variable(s):
		Local Length:= Self.Length()
		
		X = Length * Cos(Angle)
		Y = Length * Sin(Angle)
		
		Return
	End
	
	Method AngleTo:T(V:Vector2D<T>)
		Return AngleTo_2D(V)
	End
	
	Method AngleTo_2D:T(V:Vector2D<T>)
		Return HALF_FULL_ROTATION_IN_DEGREES - ATan2(Y - V.Y, X - V.X)
	End
	
	Method AngleBetweenSin:T(V:Vector2D<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return Super.AngleBetweenSin(V, VData_Length, VData_Offset)
	End
	
	Method AngleBetweenSin:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, UNUSED_TEMPVECTOR_ARG:Vector<T>=Null)
		Return AngleBetween_TransformProduct(CrossProduct_2D(A, A_Offset), A, A_Length, A_Offset, VData_Length, VData_Offset)
	End
	
	Method Perpendicular:Vector2D<T>()
		' Local variable(s):
		
		' Generate a new 2D vector.
		Local VOUT:= CloneAs2D()
		
		' Rotate the vector.
		VOUT.AsPerpendicular()
		
		' Return the output-vector.
		Return VOUT
	End
	
	Method ReversePerpendicular:Vector2D<T>()
		' Local variable(s):
		
		' Generate a new 2D vector.
		Local VOUT:= CloneAs2D()
		
		' Rotate the vector.
		VOUT.AsReversePerpendicular()
		
		' Return the output-vector.
		Return VOUT
	End
	
	Method LeftNormal:Vector2D<T>()
		Return Perpendicular()
	End
	
	Method RightNormal:Vector2D<T>()
		Return ReversePerpendicular()
	End
	
	Method AsPerpendicular:Void()
		' Local variable(s):
		Local X:= Self.X
		
		Self.X = -Y
		Self.Y = X
	End
	
	Method AsReversePerpendicular:Void()
		' Local variable(s):
		Local X:= Self.X
		
		Self.X = Y
		Self.Y = -X
		
		Return
	End
	
	Method AsLeftNormal:Void()
		AsPerpendicular()
		
		Return
	End
	
	Method AsRightNormal:Void()
		AsReversePerpendicular()
		
		Return
	End
	
	Method Add2D:Vector2D<T>(V:Vector<T>)
		' Local variable(s):
		Local VOut:= CloneAs2D()
		
		' Add the two vectors together.
		VOut.Add(V)
		
		' Return the output-vector.
		Return VOut
	End
	
	Method Subtract2D:Vector2D<T>(V:Vector<T>)
		' Local variable(s):
		Local VOut:= CloneAs2D()
		
		' Subtract the input-vector from the generated vector.
		VOut.Subtract(V)
		
		' Return the output-vector.
		Return VOut
	End
	
	Method MakeBetween2D:Vector2D<T>(V:Vector2D<T>)
		Return Vector2D<T>(MakeBetween(V))
	End
	
	Method Divide2D:Vector2D<T>(V:Vector<T>)
		' Local variable(s):
		Local VOut:= CloneAs2D()
		
		' Divide the generated vector by the input-vector.
		VOut.Divide(V)
		
		' Return the output-vector.
		Return VOut
	End
	
	Method Multiply2D:Vector2D<T>(V:Vector<T>)
		' Local variable(s):
		Local VOut:= CloneAs2D()
		
		' Multiply the generated vector by the input-vector.
		VOut.Multiply(V)
		
		' Return the output-vector.
		Return VOut
	End
	
	Method Rotate2D:Vector2D<T>(Angle:T)
		' Local variable(s):
		Local VOut:= CloneAs2D()
		
		' Rotate the generated vector by the angle specified.
		VOut.Rotate(Angle)
		
		' Return the output-vector.
		Return VOut
	End
	
	Method Project2D:Vector2D<T>(V:Vector2D<T>, Output:Vector2D<T>=Null)
		Return Project2D(V, AUTO, XPOS, Output)
	End
	
	Method Project2D:Vector2D<T>(V:Vector2D<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, Output:Vector2D<T>=Null)
		' Check for error(s):
		#If VECTOR_SAFETY
			If (V = Null) Then
				Return Null
			Endif
		#End
		
		If (Output = Null) Then
			Output = New Vector2D<T>(V)
		Else
			Output.Copy(V)
		Endif
		
		' Local variable(s):
		
		' Calculate the projection scalar.
		Local Scalar:= Output.ProjectionScalar(V, VData_Length, VData_Offset)
		
		' Apply the projection.
		Output.Project(Scalar)
		
		' Return the output-vector.
		Return Output
	End
	
	Method Normalized2D:Vector2D<T>(VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
		Return Normalized2D(Length(VData_Length, VData_Offset), VData_Length, VData_Offset, OutputVector)
	End
	
	Method Normalized2D:Vector2D<T>(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
		' Call the main implementation.
		Return Vector2D<T>(Normalized(Length, VData_Length, VData_Offset, OutputVector))
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool, FixErrors:Bool=Default_ToString_FixErrors)
		If (Not GiveName) Then
			Return (Super.ToString(False) + Comma + Space + "Y:" + Space + SingleQuote + String(GetData(YPOS)) + SingleQuote)
		Endif
		
		Return Name()
	End
	
	' Methods (Private):
	Private
	
	' The following overloads are here for the sake of privacy:
	Method Resize:Bool(Size:Int)
		Return Super.Resize(Size)
	End
	
	Method Resize:Bool()
		Return Super.Resize()
	End
	
	Method Grow:Bool(GrowthIndex:Int=AUTO)
		Return Super.Grow(GrowthIndex)
	End
	
	Method ControlledGrow:Bool(Index:Int=AUTO)
		Return Super.ControlledGrow(Index)
	End
	
	Public
	
	' Properties (Public):
	Method Angle:T() Property
		Return HALF_FULL_ROTATION_IN_DEGREES - ATan2(-Y, -X)
	End
	
	Method Angle:Void(Input:T) Property
		' Local variable(s):
		Local Length:= Self.Length()
		
		X = Length * Cos(Input)
		Y = Length * -Sin(Input)
		
		Return
	End
	
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
	
	Method Size:Int() Property
		Return Super.Size()
	End
	
	' Properties (Private):
	Private
	
	Method Size:Void(Input:Int) Property
		Super.Size(Input)
		
		Return
	End
	
	Public
	
	' Fields:
	' Nothing so far.
End

Class Vector3D<T> Extends Vector2D<T>
	' Constant variables:
	Const ZPOS:= Vector<T>.ZPOS
	Const VECTORSIZE:Int = 3
	
	' Global variable(s):
	
	' The name of this class.
	Global Name_Str:String = "Vector(3D)"

	' Functions:
	Function Name:String()
		Return Name_Str
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
	
	Method New(Info:T[], CopyInfo:Bool)
		Super.New(Info, CopyInfo)
	End
	
	Method New(Info:T[], Size:Int=VECTORSIZE, Offset:Int=XPOS)
		Super.New(Info, Size, Offset)
	End
	
	Method New(V:Vector<T>, Size:Int=VECTORSIZE, Offset:Int=XPOS)
		Super.New(V, Size, Offset)
	End
	
	Method New(X:T, Y:T, Z:T=NIL, VECTORSIZE:Int=Vector3D<T>.VECTORSIZE)
		Super.New(X, Y, VECTORSIZE)
		
		Self.Z = Z
	End
	
	' Methods:
	Method Clone:Vector<T>()
		Return CloneAs3D()
	End
	
	Method CloneAs3D:Vector3D<T>()
		Return New Vector3D<T>(GetData())
	End
	
	Method CrossProduct:Vector<T>(V:Vector<T>, VOUT:Vector<T>=Null)
		' Local variable(s):
		Local V3D:= Vector3D<T>(V)
		Local V3DOut:Vector3D<T>
		
		#If VECTOR_SAFETY
			If (V3D = Null) Then
				Return Null
			Endif
		#End
		
		#If VECTOR_SAFETY
			If (VOUT <> Null) Then
		#End
				V3DOut = Vector3D<T>(VOUT)
				
				#If VECTOR_SAFETY
					If (V3DOut = Null) Then
						Return Null
					Endif
				#End
		#If VECTOR_SAFETY
			Endif
		#End
		
		' Call the main implementation.
		Return CrossProduct3D(V3D, V3DOut)
	End
	
	Method CrossProduct3D:Vector3D<T>(V:Vector3D<T>, VOUT:Vector3D<T>=Null)
		If (VOUT = Null) Then
			VOUT = New Vector3D<T>(Self)
		Else
			VOUT.Copy(Self)
		Endif
		
		VOUT.CrossProduct_3D(V)
		
		Return VOUT
	End
	
	Method CrossProduct_3D:Void(V:Vector3D<T>)
		' Local variable(s):
		
		' Cache the internal-data locally:
		Local X:= Self.X
		Local Y:= Self.Y
		Local Z:= Self.Z
		
		' Calculate the product:
		Self.X = Y*V.Z - Z*V.Y
		Self.Y = Z*V.X - X*V.Z
		Self.Z = X*V.Y - Y*V.X
		
		Return
	End
	
	Method MakeBetween3D:Vector3D<T>(V:Vector3D<T>)
		Return Vector3D<T>(MakeBetween(V))
	End
	
	Method RotateTowards:Void(V:Vector2D<T>)
		' Local variable(s):
		
		' Check if the input was a 'Vector3D'.
		Local V3D:= Vector3D<T>(V)
		
		If (V3D <> Null) Then
			RotateTowards_3D(V3D)
		Else
			Local Product:= CrossProduct_2D(V)
			
			Rotate_2DIn3D(Cos(Product), Sin(Product))
		Endif
		
		Return
	End
	
	Method Rotate:Void(Angle:T)
		Rotate_2DIn3D(Cos(Angle), Sin(Angle))
		
		Return
	End
	
	Method Rotate_2DIn3D:Void(V:Vector2D<T>)
		Rotate_2DIn3D(V.X, V.Y)
		
		Return
	End
	
	Method Rotate_2DIn3D:Void(RX:T, RY:T)
		Rotate_2DIn3D(RX, RY, Length())
		
		Return
	End
	
	Method Rotate_2DIn3D:Void(RX:T, RZ:T, Length:T)
		X = Length * RX
		Z = Length * RZ
		
		Return
	End
	
	Method Rotate_3D:Void(RX:T, RY:T, RZ:T)
		Rotate_3D(RX, RY, RZ, Length())
		
		Return
	End
	
	Method Rotate_3D:Void(RX:T, RY:T, RZ:T, Length:T)
		Rotate_2DIn3D(RX, RZ, Length)
		
		Y = Length * RY
		
		Return
	End
	
	Method Rotate_3D:Void(R:Vector3D<T>)
		Rotate_3D(R.X, R.Y, R.Z)
		
		Return
	End
	
	Method RotateTowards_3D:Void(V:Vector3D<T>, TempVector:Vector3D<T>=Null)
		Rotate_3D(Vector3D<T>(CrossProduct(V, TempVector)))
		
		Return
	End
	
	Method AngleTo:T(V:Vector2D<T>)
		' Local variable(s):
		
		' Check if the input was a 'Vector3D'.
		Local V3D:= Vector3D<T>(V)
		
		If (V3D <> Null) Then
			Return AngleTo_3D(V3D)
		Endif
		
		Return AngleTo_2D(V)
	End
	
	Method AngleTo_3D:T(V:Vector3D<T>)
		Return HALF_FULL_ROTATION_IN_DEGREES - ATan2(Z - V.Z, X - V.X)
	End
	
	Method Normalized3D:Vector3D<T>(VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
		Return Normalized3D(Length(VData_Length, VData_Offset), VData_Length, VData_Offset, OutputVector)
	End
	
	Method Normalized3D:Vector3D<T>(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
		' Call the main implementation.
		Return Vector3D<T>(Normalized(Length, VData_Length, VData_Offset, OutputVector))
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool, FixErrors:Bool=Default_ToString_FixErrors)
		If (Not GiveName) Then
			Return (Super.ToString(False) + Comma + Space + "Z:" + Space + SingleQuote + String(GetData(ZPOS)) + SingleQuote)
		Endif
		
		Return Name()
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

#Rem
	IMPLEMENTATION NOTES:
		* This class and classes based on this aren't exactly mathematical in nature.
		You can use this with most (If not all) of the usual mathematical commands,
		however, this does not support aliases for vector generation.
		
		* This class is mainly for things like color-data, and other less mathematical uses.
		But, that doesn't mean it won't support such things.
#End

Class Vector4D<T> Extends Vector3D<T>
	' Constant variables:
	Const APOS:Int = XPOS
	Const BPOS:Int = YPOS
	Const CPOS:Int = ZPOS
	Const DPOS:Int = ZPOS+1
	
	Const VECTORSIZE:Int = 4
	
	' Global variable(s):
	
	' The name of this class.
	Global Name_Str:String = "Vector(4D)"

	' Functions:
	Function Name:String()
		Return Name_Str
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
	
	Method New(Info:T[], CopyInfo:Bool)
		Super.New(Info, CopyInfo)
	End
	
	Method New(Info:T[], Size:Int=VECTORSIZE, Offset:Int=XPOS)
		Super.New(Info, Size, Offset)
	End
	
	Method New(V:Vector<T>, Size:Int=VECTORSIZE, Offset:Int=XPOS)
		Super.New(V, Size, Offset)
	End
	
	Method New(A:T, B:T, C:T=NIL, D:T=NIL, VECTORSIZE:Int=Vector4D<T>.VECTORSIZE)
		Super.New(A, B, C, VECTORSIZE)
		
		Self.D = D
	End

	' Methods:
	Method Clone:Vector<T>()
		Return CloneAs4D()
	End
	
	Method CloneAs4D:Vector4D<T>()
		Return New Vector4D<T>(GetData())
	End
	
	Method MakeBetween4D:Vector4D<T>(V:Vector4D<T>)
		Return Vector4D<T>(MakeBetween(V))
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool, FixErrors:Bool=Default_ToString_FixErrors)
		If (Not GiveName) Then
			' Local variable(s):
			Local OutStr:= Super.ToString(False)
			
			OutStr = OutStr.Replace("X", "A")
			OutStr = OutStr.Replace("Y", "B")
			OutStr = OutStr.Replace("Z", "C")
		
			Return (OutStr + Comma + Space + "D:" + Space + SingleQuote + String(GetData(DPOS)) + SingleQuote)
		Endif
		
		Return Name()
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
	
	' Defaults:
	Const Default_ExactGrowthThreshold:Int = VECTORSIZE
	
	' Global variable(s):
	
	' The name of this class.
	Global Name_Str:String = "Vector"
	
	' Functions:
	Function Name:String()
		Return Name_Str
	End

	' Constructor(s):
	Method New()
		Super.New(VECTORSIZE)
	End
	
	Method New(Info:T[], CopyInfo:Bool)
		Super.New(Info, CopyInfo)
	End
	
	Method New(Info:T[], Size:Int=VECTORSIZE, Offset:Int=XPOS)
		Super.New(Info, Size, Offset)
	End
	
	Method New(V:Vector<T>, Size:Int=VECTORSIZE, Offset:Int=XPOS)
		Super.New(V, Size, Offset)
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
	Method Clone:Vector<T>()
		Return CloneAsManualVector()
	End
	
	Method CloneAsManualVector:ManualVector<T>()
		Return New ManualVector<T>(GetData())
	End
	
	Method Index:T[]()
		Return GetData()
	End
	
	Method Index:T(I:Int)
		Return GetData(I)
	End
	
	Method ToString:String()
		Return ToString(False)
	End
	
	Method ToString:String(GiveName:Bool, FixErrors:Bool=True)
		If (Not GiveName) Then
			Local OutStr:String
			
			#If VECTOR_TOSTRING_USE_GENERIC_UTIL
				OutStr = GenericUtilities<T>.AsString(GetData())
			#Else
				For Local Index:= XPOS Until Size
					OutStr += String("[" + String(Index) + "]: " + SingleQuote + String(GetData(Index)) + SingleQuote)
					
					If (Index < LastIndex) Then
						OutStr += (Comma + Space)
					Endif
				Next
			#End
			
			If (FixErrors) Then
				If (OutStr.Find(SingleQuote+SingleQuote) <> -1) Then
					Return OutStr.Replace(SingleQuote + SingleQuote, SingleQuote + "?" + SingleQuote)
				Endif
			Endif
			
			Return OutStr
		Endif
		
		Return Name()
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
	
	Method AutoGrow:Bool() Property
		Return Super.AutoGrow()
	End
	
	Method AutoGrow:Void(Input:Bool) Property
		Super.AutoGrow(Input)
		
		Return
	End
	
	Method ExactGrowthThreshold:Int() Property
		Return Self._ExactGrowthThreshold
	End
	
	Method ExactGrowthThreshold:Void(Input:Int) Property
		Self._ExactGrowthThreshold = Input
		
		Return
	End
	
	' Properties (Private):
	Private
	
	' Nothing so far.
	
	Public
	
	' Fields (Public):
	' Nothing so far.
	
	' Fields (Private):
	Private
	
	' I'm not normally one to do this, but...
	Field _ExactGrowthThreshold:Int = Default_ExactGrowthThreshold
	
	Public
End

' Functions:
Function DotProductNormalized:Float(V1:Vector<Float>, V2:Vector<Float>)
	Return AbstractVector<Float>.DotProductNormalized(V1, V2)
End