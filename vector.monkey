Strict

Public

#Rem
	TODO:
		* Change several uses of "Data.Length()" to use the 'Size' property.
		
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

' Imports:

' BRL:
Import brl.stream

' ImmutableOctet:
Import util
Import ioelement

' Global variable(s):
' Nothing so far.

' Constant variable(s):
Const VECTOR_AUTO:Int = -1

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
	
	' Methods (Public):
	
	' Conversion commands:
	Method ToString:String()
	Method ToString:String(GiveName:Bool, FixErrors:Bool=True)
	
	' General purpose commands:
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
	
	Method Length:T(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method LinearInterpolation:Void(V:Vector<T>, t:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method LinearInterpolation:Void(A:T[], t:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
	
	Method Normalize:Void()
	Method Normalize:Void(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	Method DotProduct:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method DotProduct:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method DotProductNormalized:T(V:Vector<T>)
	
	Method SubtractTowardsZero:Void(Time:T=T(1.0), VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
	' Methods (Private):
	Private
	
	Method Resize:Bool()
	Method Resize:Bool(Size:Int)
	
	Method Grow:Bool(GrowthIndex:Int=AUTO)
	Method ControlledGrow:Bool(Index:Int=AUTO)
	
	Public
	
	' Properties (Public):
	Method Data:T[]() Property
	Method Size:Int() Property
	
	Method X:T() Property
	Method X:Void(Info:T) Property
	
	' Properties (Private):
	Private
	
	' Nothing so far.
	
	Public
End

' Classes:
Class AbstractVector<T> Implements Vector<T>, SerializableElement ' Abstract
	' Constant variables:
	Const XPOS:= Vector<T>.XPOS
	
	Const VECTORSIZE:Int			= 1
	
	Const AUTO:= VECTOR_AUTO
	
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
	
	Method New(V:Vector<T>, Size:Int=AUTO)
		' Local variable(s):
		Local FitVector:Bool = False
		
		' Check if the size was specified:
		If (Size = AUTO) Then
			Size = V.Size
			
			FitVector = True
		Endif
		
		' Create the internal container.
		CreateData(Size)
		
		' Copy the internal data of 'V'.
		Assign(V, FitVector)
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
		Return New AbstractVector<T>(Data)
	End
	
	Method Clone:Void(V:Vector<T>)
		Assign(V)
		
		Return
	End
	
	Method Copy:Void(V:Vector<T>)
		Clone(V)
		
		Return
	End
	
	Method Copy:Void(Info:T[], Size:Int=AUTO, Offset:Int=XPOS)
		Assign(Info, Size, Offset)
		
		Return
	End
	
	Method Assign:Void(V:Vector<T>, FitVector:Bool=False)
		' Check for errors:
		#If VECTOR_SAFETY
			If (V = Null) Then Return
		#End
		
		Assign(V.Data, FitVector)
	
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
		
		Self.Data = GenericUtilities<T>.CopyArray(Info, Self.Data, FitInfo)
		
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
			Data[I] = NIL ' T(0)
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
			Data[I] = -Data[I]
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
		
		Local VelocityLength:Float = Length()
		
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
						Data[Index] *= (T(1.0)/A_On_Index)
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
					Multiply(T(1.0)/F, VData_Length, VData_Offset)
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
	
	Method Length:T(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		Local Sum:T = NIL
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Sum += Data[Index]*Data[Index] ' Pow(..., 2)
		Next
		
		Return Sqrt(Sum)
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
			t = Clamp(t, T(0.0), T(1.0))
		#End
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			Data[Index] = Data[Index] + (A[Index]-Data[Index]) * t
		Next
		
		Return
	End
	
	Method Normalize:Void()
		Normalize(Length())
		
		Return
	End
	
	Method Normalize:Void(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		If (Length <> NIL) Then
			Divide(Length, VData_Length, VData_Offset)
		Endif
		
		Return
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
	
	Method SubtractTowardsZero:Void(Time:T=T(1.0), VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		' Ensure we have a valid delta.
		#If VECTOR_NUMBER_SAFETY
			Time = Clamp(Time, T(0), T(1))
		#End
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
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
	
	Method New(V:Vector<T>, Size:Int=VECTORSIZE)
		Super.New(V, Size)
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
	
	Method Perpendicular:Vector2D<T>()
		Local V:= New Vector2D<T>()
		
		V.AsPerpendicular(X, Y)
		
		Return V
	End
	
	Method AsPerpendicular:Void(V:Vector2D<T>)
		AsPerpendicular(V.X, V.Y)
		
		Return
	End
	
	Method AsPerpendicular:Void()
		'AsPerpendicular(X, Y)
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
	
	Method Add2D:Vector2D<T>(V:Vector<T>)
		Local VOut:= (New Vector2D<T>(Self))
		
		VOut.Add(V)
		
		Return VOut
	End
	
	Method Subtract2D:Vector2D<T>(V:Vector<T>)
		Local VOut:= (New Vector2D<T>(Self))
		
		VOut.Subtract(V)
		
		Return VOut
	End
	
	Method Divide2D:Vector2D<T>(V:Vector<T>)
		Local VOut:= (New Vector2D<T>(Self))
		
		VOut.Divide(V)
		
		Return VOut
	End
	
	Method Multiply2D:Vector2D<T>(V:Vector<T>)
		Local VOut:= (New Vector2D<T>(Self))
		
		VOut.Multiply(V)
		
		Return VOut
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
	
	Method New(V:Vector<T>, Size:Int=VECTORSIZE)
		Super.New(V, Size)
	End
	
	Method New(X:T, Y:T, Z:T=NIL, VECTORSIZE:Int=Vector3D<T>.VECTORSIZE)
		Super.New(X, Y, VECTORSIZE)
		
		Self.Z = Z
	End
	
	' Methods:
	Method Clone:Vector<T>()
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
	
	Method New(V:Vector<T>, Size:Int=VECTORSIZE)
		Super.New(V, Size)
	End
	
	Method New(A:T, B:T, C:T=NIL, D:T=NIL, VECTORSIZE:Int=Vector4D<T>.VECTORSIZE)
		Super.New(A, B, C, VECTORSIZE)
		
		Self.D = D
	End

	' Methods:
	Method Clone:Vector<T>()
		Return New Vector4D<T>(GetData())
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
	
	Method New(V:Vector<T>, Size:Int=AUTO)
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
	Method Clone:Vector<T>()
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
Function DotProductNormalized:Float(V1:AbstractVector<Float>, V2:AbstractVector<Float>)
	Return AbstractVector<Float>.DotProductNormalized(V1, V2)
End