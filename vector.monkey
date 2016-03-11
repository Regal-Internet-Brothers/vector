Strict

Public

#Rem
	TODO:
		* Change several uses of "Data.Length" to use the 'Size' property.
		* Remove the limitation of not being able to offset the internal-data of the active vector properly. (Horribly complicated)
		* Rewrite the current "AUTO" based system; overload hell.
		* Look over existing comments and documentation.
		
	COMMAND NAMING CONVENTIONS:
		* The names of commands (Methods, functions, etc) usually indicate the return value of said command.
		
		For example, most commands ending with an underscore ("_"), then the class's "dimension tag" ("2D", "3D", etc) will likely not return a vector object.
		Whereas a command which does not have an underscore as a seperator will very likely return a vector of some kind (Generated, usually).
		
		See commands like the 'Vector2D' class's 'Add2D', and the 'Vector3D' class's 'Rotate_3D' as examples.
		
		* Most methods (Unless explicitly stated otherwise) will affect the vector they're used from.
		
		For example, the 'Add' command found in the 'Vector' class does not produce a vector of any kind.
		This command only affects its own object's ('Self') data, meaning it will mutate based on the input.
		
		However, it will likely not mutate the input itself.
		
		* Any names you find in this module starting with the word "Alternate" are subject to change at any point.
		These elements are used by my own projects, and their underlying functionality will not be set in stone.
		
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
		
		This operator is also common in this module (And my other modules) when type-information is unimportant.
		
		* THESE RULES DO NOT APPLY TO ALL MODULES I RELEASE, BUT THEY DEFINITELY APPLY HERE.
		
		* If you're interested in better performance with some C++ compilers, you might want to look into SSE and AVX optimization options.
		I wrote some basic information about this in my 'hash' module.
		
		That functionality is not available here, but the notes I wrote could be of interest.
		Optimizations applied in that module will likely apply to this one.
#End

' Preprocessor related:
#VECTOR_IMPLEMENTED = True

#Rem
	VECTOR_TYPEFIXES:
		DESCRIPTION:
			* If this is enabled, hacks will be used in order to support non-numeric types, such as Monkey's standard "box" classes.
			Default behavior for this module is to automatically enabled this functionality if the reflection filter is set to something.
			
			If you intend to use vectors made from the standard "box" classes, make sure to manually set this to 'True'.
			(Especially if you're using reflection, though this should handle that already)
		NOTES:
			* Work has been done specifically to support the standard box types. Don't expect to have the same optimizations and/or fixes
			for other types that use "auto boxing". That being said, assuming your conversion isn't ambiguous, this should still work with such types.
			
			* Some names for normally standard commands are different in this module;
			this is because of conflicts with the current version of Monkey (As of the time I'm writing this).
			
			Such commands will be backed by the standard implementations automatically.
			That being said, some of the fixes and other such hacks done within this module may provide
			alternate implementations for the standard "box" classes.
			
			These implementations should still follow the standard behavior defined by Monkey's standards of conduct.
			
			In addition, this module reserves the right to reimplement the standard commands' behaviors at will, even if that likely will never be necessary.
#End

#If REFLECTION_FILTER
	#VECTOR_TYPEFIXES = True
#Else
	#VECTOR_TYPEFIXES = False
#End

#VECTOR_SUPPORTLAYER_TYPEFIXES = VECTOR_TYPEFIXES

#VECTOR_ZERO_WITH_NIL = True

#Rem
	Basically, if you disable this, class-specific
	implementations of shared commands may be used.
	
	If you enable this, several implementations of
	a normally shared command may be used.
	
	Enabling this is generally faster, but you
	should probably leave this variable alone.
	
	This is only used for cases where class-specific
	implementations of a command are effectively identical.
	
	The big example here being the 'MakeBetween' command,
	and similar commands which generate new vectors.
	
	This can happen pretty often where 'Clone' is used.
	
	This setting does not affect class-specific commands
	like the 'Vector2D' class's 'MakeBetween2D' method.
	
	This does not act as a rule, it acts as a guideline;
	the value of this preprocessor variable does not
	directly dictate this module's final decisions.
#End

#VECTOR_SHARE_OPTIMIZATIONS = True

#Rem
	These variables toggle specific checks which may improve
	program stability and sometimes, even performance.
	Unless you're seriously looking into debugging
	this module, don't bother changing these.
#End

#VECTOR_SAFETY = True ' False

#If CONFIG = "debug"
	#VECTOR_NUMBER_SAFETY = True
#End

' If this is enabled, the standard I/O methods will be implemented.
#VECTOR_ALLOW_SERIALIZATION = True

' Imports (Public):
' Nothing so far.

' Imports (Private):
Private

' External:
Import regal.util
Import regal.sizeof
Import regal.boxutil
Import regal.ioelement

Import brl.stream

' Internal:
Import supportlayer

Public

' The following operations must be done in order to configure the module(s) imported afterword:
#If VECTOR_SUPPORTLAYER_TYPEFIXES
	#Rem
		DESCRIPTION:
			* The support layer's "memory over-optimization" functionality basically
			allows heavy re-use of objects without constraint.
			
			As an example, if a command takes an 'IntObject', then this will re-use the initial object.
			
			For this reason, when the support layer is delegated, the default behavior is to not apply such optimizations.
			This is done due to the intrusive nature of this functionality.
			
			A user could easily experience unintended side-effects with this feature enabled.
			This module (On the other hand) is designed to support this feature.
	#End
	
	#VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY = (BOXUTIL_IMPLEMENTED)
#End

' Constant variable(s):
Const VECTOR_AUTO:= UTIL_AUTO

' Property data-positions:
Const VECTOR_XPOSITION:= 0
Const VECTOR_YPOSITION:= 1
Const VECTOR_ZPOSITION:= 2
Const VECTOR_WPOSITION:= 3

' Classes:
Class Vector<T> Implements SerializableElement Abstract
	' Constant variable(s):
	Const XPOS:= VECTOR_XPOSITION
	Const YPOS:= VECTOR_YPOSITION
	Const ZPOS:= VECTOR_ZPOSITION
	Const WPOS:= VECTOR_WPOSITION
	
	Const AUTO:= VECTOR_AUTO
	
	' The size of this vector-type.
	Const INTERNAL_SIZE:Int = 1
	
	' Error template(s):
	Const VECTOR_GENERIC_ERROR_TEMPLATE:String = "{VECTOR} {ERROR}: "
	
	' Global variable(s):
	
	' The default value of the type specified.
	Global NIL:T
	
	#If VECTOR_ZERO_WITH_NIL
		Global ZERO:= NIL
	#Else
		Global ZERO:= T(0)
	#End
	
	Global ONE:= T(1)
	Global TWO:= T(2)
	
	Global FULL_ROTATION_IN_DEGREES:T = T(360)
	Global HALF_FULL_ROTATION_IN_DEGREES:T = T(180.0)
	
	' Functions:
	Function Name:String()
		Return "Vector (Abstract)"
	End
	
	Function VectorError:Void(Message:String, Template:String=VECTOR_GENERIC_ERROR_TEMPLATE)
		DebugError(Template+Message)
		
		Return
	End
	
	' Math routines:
	Function SumSquared:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		Local Sum:T = ZERO
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			Sum += Sq(A[Index])
		Next
		
		Return Sum
	End
	
	Function Length:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		Return Sqrt(SumSquared(A, A_Length, A_Offset))
	End

	' Constructor(s) (Public):
	Method New(Size:Int)
		CreateData(Size)
	End
	
	Method New(Value:T[], CopyValue:Bool)
		If (CopyValue) Then
			Assign(Value)
		Else
			AssignByRef(Value)
		Endif
	End
	
	Method New(Value:T[], Size:Int=AUTO, Offset:Int=XPOS)
		Assign(Value, Size, Offset)
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
	
	Method Clone:Vector<T>() Abstract
	
	Method Clone:Void(V:Vector<T>, FitVector:Bool)
		Assign(V, FitVector)
		
		Return
	End
	
	Method Clone:Void(V:Vector<T>, Size:Int=AUTO, Offset:Int=XPOS, FitVector:Bool=False)
		Assign(V, Size, Offset, FitVector)
		
		Return
	End
	
	' Constructor(s) (Protected):
	Protected
	
	Method CreateData:Void(Size:Int)
		Data = New T[Size]
		
		Return
	End
	
	Public
	
	' Methods:
	Method ToString:String()
		Return ("X: '" + String(X) + "'")
	End
	
	' This performs a raw equality check; use at your own risk.
	Method Equals:Bool(V:Vector<T>)
		If (V.Size <> Self.Size) Then
			Return False
		Endif
		
		For Local I:= 0 Until V.Size
			If (Data[I] <> V.Data[I]) Then
				Return False
			Endif
		Next
		
		' Return the default response.
		Return True
	End
	
	Method Copy:Void(V:Vector<T>, FitVector:Bool)
		Clone(V, FitVector)
		
		Return
	End
	
	Method Copy:Void(V:Vector<T>, Size:Int=AUTO, Offset:Int=XPOS, FitVector:Bool=False)
		Clone(V, Size, Offset, FitVector)
		
		Return
	End
	
	Method Copy:Void(Value:T[], FitValue:Bool)
		Copy(Value, AUTO, XPOS, FitValue)
		
		Return
	End
	
	Method Copy:Void(Value:T[], Size:Int=AUTO, Offset:Int=XPOS, FitValue:Bool=False)
		Assign(Value, Size, Offset, FitValue)
		
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
	
	Method Assign:Void(Value:T[], FitValue:Bool)
		Assign(Value, AUTO, XPOS, FitValue)
		
		Return
	End
	
	Method Assign:Void(Value:T[], Size:Int=AUTO, Offset:Int=XPOS, FitValue:Bool=True)
		If (Size = AUTO) Then
			Size = Value.Length
		Endif
		
		'AssignByRef(GenericUtilities<T>.CopyArray(Value, Self.Data, FitValue))
		'AssignByRef(Value.Resize(Size))
		AssignByRef(GenericUtilities<T>.CopyArray(Value, Self.Data, Offset, XPOS, Size, AUTO, FitValue))
		
		Return
	End
	
	Method AssignByRef:Void(Value:T[])
		Self.Data = Value
		
		Return
	End
	
	Method Zero:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
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
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Data[I] = AbsoluteNumber(Data[I])
		Next
		
		Return
	End
	
	Method Negate:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Data[I] = NegateNumber(Data[I])
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
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Self.Data[I] = MinimumNumber(Self.Data[I], Value)
		Next
		
		Return
	End
	
	Method ApplyMax:Void(Value:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Self.Data[I] = MaximumNumber(Self.Data[I], Value)
		Next
		
		Return
	End
	
	Method ApplyClamp:Void(MinValue:T, MaxValue:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			Self.Data[I] = ClampNumber(Self.Data[I], MinValue, MaxValue)
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
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = AddNumbers(Data[Index], A[Index])
			#Else
				Data[Index] += A[Index]
			#End
		Next
		
		Return
	End
	
	' This overload adds by scalar, instead of by vector.
	Method Add:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = AddNumbers(Data[Index], F)
			#Else
				Data[Index] += F
			#End
		Next
		
		Return
	End
	
	Method DeltaAdd:Void(V:Vector<T>, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		DeltaAdd(V.Data, Scalar, VData_Length, VData_Offset)
		
		Return
	End
	
	Method DeltaAdd:Void(A:T[], Scalar:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = DeltaAddNumbers(Data[Index], A[Index], Scalar)
			#Else
				Data[Index] += (A[Index] * Scalar)
			#End
		Next
		
		Return
	End
	
	Method DeltaAdd:Void(F:T, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = DeltaAddNumbers(Data[Index], F, Scalar)
			#Else
				Data[Index] += (F * Scalar)
			#End
		Next
		
		Return
	End
	
	Method DeltaSubtract:Void(V:Vector<T>, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		DeltaSubtract(V.Data, Scalar, VData_Length, VData_Offset)
		
		Return
	End
	
	Method DeltaSubtract:Void(A:T[], Scalar:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = DeltaSubtractNumbers(Data[Index], A[Index], Scalar)
			#Else
				Data[Index] -= (A[Index] * Scalar)
			#End
		Next
		
		Return
	End
	
	Method DeltaSubtract:Void(F:T, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = DeltaSubtractNumbers(Data[Index], F, Scalar)
			#Else
				Data[Index] -= (F * Scalar)
			#End
		Next
	End
	
	Method Decelerate:Void(Deceleration:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		Local VelocityLength:= Length
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Local Value:= InnerValue(Data[Index])
			#Else
				Local Value:= Data[Index]
			#End
			
			If (Value > 0.0) Then
				Data[Index] = MaximumNumber(T(Value-(((Value / VelocityLength)*Deceleration))), ZERO)
			Else
				Data[Index] = MinimumNumber(T(Value-(((Value / VelocityLength)*Deceleration))), ZERO)
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
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = SubtractNumber(Data[Index], A[Index])
			#Else
				Data[Index] -= A[Index]
			#End
		Next
		
		Return
	End
	
	' Subtract by scalar, instead of by vector.
	Method Subtract:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = SubtractNumber(Data[Index], F)
			#Else
				Data[Index] -= F
			#End
		Next
		
		Return
	End
	
	Method Divide:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Divide(V.Data, VData_Length, VData_Offset)
		
		Return
	End
	
	Method Divide:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = DivideNumber(Data[Index], A[Index])
			#Else
				Data[Index] /= A[Index]
			#End
		Next
		
		Return
	End
	
	Method Divide:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = DivideNumber(Data[Index], F)
			#Else
				Data[Index] /= F
			#End
		Next
		
		Return
	End
	
	Method Multiply:Void(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Multiply(V.Data, VData_Length, VData_Offset)
		
		Return
	End
	
	Method Multiply:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = MultiplyNumbers(Data[Index], A[Index])
			#Else
				Data[Index] *= A[Index]
			#End
		Next
		
		Return
	End
	
	Method Multiply:Void(F:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		For Local Index:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = MultiplyNumbers(Data[Index], F)
			#Else
				Data[Index] *= F
			#End
		Next
		
		Return
	End
	
	Method LinearInterpolation:Void(V:Vector<T>, t:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		LinearInterpolation(V.Data, t, VData_Length, VData_Offset)
		
		Return
	End
	
	Method LinearInterpolation:Void(A:T[], t:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		#If VECTOR_NUMBER_SAFETY
			t = ClampNumber(t, ZERO, ONE)
		#End
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Data[Index] = DeltaAddNumbers(Data[Index], T(InnerValue(A[Index])-InnerValue(Data[Index])), t)
			#Else
				Data[Index] += (A[Index]-Data[Index]) * t
			#End
		Next
		
		Return
	End
	
	Method Normalize:Void(VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Normalize(Length(VData_Length, VData_Offset), VData_Length, VData_Offset)
		
		Return
	End
	
	Method Normalize:Void(Length:T, VData_Length:Int, VData_Offset:Int)
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
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
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
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				D += Sq(InnerValue(A[Index])-InnerValue(Data[Index]))
			#Else
				D += Sq(A[Index]-Data[Index])
			#End
		Next
		
		#If Not VECTOR_SUPPORTLAYER_TYPEFIXES
			Return Sqrt(D)
		#Else
			Return Sqrt(InnerValue(D))
		#End
	End
	
	Method Offset:T(Amount:T)
		Add(Amount)
		
		Return Amount
	End
	
	Method DotProduct:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return DotProduct(V.Data, VData_Length, VData_Offset)
	End
	
	Method DotProduct:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
		' Local variable(s):
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		Local Sum:T = NIL
		
		For Local Index:= A_Offset Until Min(Data.Length, Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Sum += (InnerValue(Data[Index])*InnerValue(A[Index]))
			#Else
				Sum += Data[Index]*A[Index]
			#End
		Next
		
		Return Sum
	End
	
	#Rem
		ARGUMENT NOTES:
			* The 'V_Length' and 'V_Offset' arguments are referring to the 'V' argument.
			* The 'VData_Length' and 'VData_Offset' arguments are referring to the current vector (Self).
	#End
	
	Method DotProductNormalized:T(V:Vector<T>, FTV:Vector<T>, STV:Vector<T>)
		
		' Generate or mutate the two vectors:
		FTV.Copy(Self)
		STV.Copy(V)
		
		' Normalize the two vectors:
		FTV.Normalize()
		STV.Normalize()
		
		' Return the calculated result.
		Return FTV.DotProduct(STV)
	End
	
	Method SubtractTowardsZero:Void(Time:T=ONE, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		' Local variable(s):
		Local VData_RawLength:= Data.Length
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		' Ensure we have a valid delta.
		#If VECTOR_NUMBER_SAFETY
			Time = ClampNumber(Time, ZERO, ONE)
		#End
		
		For Local I:= VData_Offset Until Min(VData_Length, VData_RawLength)
			#If Not VECTOR_SUPPORTLAYER_TYPEFIXES
				Local Value:= Data[I]
			#Else
				Local Value:= InnerValue(Data[I])
			#End
			
			If (Value > ZERO) Then
				Data[I] = MaximumNumber(T(Value-(Value*Time)), ZERO)
			Else
				Data[I] = MinimumNumber(T(Value-(Value*Time)), ZERO)
			Endif
		Next
		
		Return
	End
	
	Method ProjectionScalar:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return ProjectionScalar(V.Data, VData_Length, VData_Offset)
	End
	
	Method ProjectionScalar:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return DivideNumber(DotProduct(A, A_Length, A_Offset), LengthScalar(A, A_Length, A_Offset, VData_Length, VData_Offset))
		#Else
			Return (DotProduct(A, A_Length, A_Offset) / LengthScalar(A, A_Length, A_Offset, VData_Length, VData_Offset))
		#End
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
		Local VectorOutput:= Clone()
		
		VectorOutput.Subtract(V)
		
		' Return the output-vector.
		Return VectorOutput
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
			TempVector = New Vector(A, A_Length, A_Offset)
		Else
			TempVector.Copy(A, A_Length, A_Offset)
		Endif
		
		Return AngleBetween_TransformProduct(CrossProduct(TempVector).X, A, A_Length, A_Offset, VData_Length, VData_Offset)
	End
	
	Method AngleBetween_TransformProduct:T(Product:T, A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return T(InnerValue(Product) / InnerValue(LengthScalar(A, A_Length, A_Offset, VData_Length, VData_Offset)))
		#Else
			Return (Product / LengthScalar(A, A_Length, A_Offset, VData_Length, VData_Offset))
		#End
	End
	
	Method LengthScalar:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		Return LengthScalar(V, VData_Length, VData_Offset)
	End
	
	Method LengthScalar:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return MultiplyNumbers(Length(VData_Length, VData_Offset), Length(A, A_Length, A_Offset))
		#Else
			Return (Length(VData_Length, VData_Offset) * Length(A, A_Length, A_Offset))
		#End
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
	
	Method SumSquared:T(VData_Length:Int, VData_Offset:Int)
		Return SumSquared(Self.Data, VData_Length, VData_Offset)
	End
	
	Method Length:T(VData_Length:Int, VData_Offset:Int)
		Return Length(Self.Data, VData_Length, VData_Offset)
	End
	
	Method CrossProduct:Vector<T>(V:Vector<T>, VectorOutput:Vector<T>=Null)
		Return Null
	End
	
	#If VECTOR_ALLOW_SERIALIZATION
		Method Load:Bool(S:Stream)
			Return Read(S)
		End
		
		Method Save:Bool(S:Stream)
			Return Write(S)
		End
		
		Method Read:Bool(S:Stream, ReadSize:Int)
			' Check for errors:
			#If VECTOR_SAFETY
				If (S = Null Or S.Eof()) Then
					Return False
				Endif
			#End
			
			GenericUtilities<T>.Read(S, Self.Data, ReadSize)
			
			' Return the default response.
			Return True
		End
		
		Method Read:Bool(S:Stream)
			Return Read(S, Self.Data.Length)
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
	#End
	
	' Legacy API:
	Method GetData:T[]() Property
		Return Data
	End
	
	' Properties:
	Method Data:T[]() Property
		Return Self._Data
	End
	
	Method Data:Void(Input:T[]) Property
		Self._Data = Input
		
		Return
	End
	
	Method X:T() Property Final
		Return Data[XPOS]
	End
	
	Method X:Void(Value:T) Property Final
		Data[XPOS] = Value
	
		Return
	End
	
	Method Length:T() Property
		Return Length(AUTO, XPOS)
	End
	
	Method SumSquared:T() Property
		Return SumSquared(AUTO, XPOS)
	End
	
	Method Length:Void(Value:T) Property
		' Local variable(s):
		#If Not VECTOR_SUPPORTLAYER_TYPEFIXES
			Local Length:= Self.Length
		#Else
			Local Length:= InnerValue(Length)
		#End
		
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
		Return Data.Length
	End
	
	Method SizeInBytes:Int() Property
		Return (Size * sizeof.SizeOf(X))
	End
	
	Method LastIndex:Int() Property
		Return (Size-1)
	End
	
	' Fields (Public):
	' Nothing so far.
	
	' Fields (Protected):
	Protected
	
	' The internal data container.
	Field _Data:T[]
	
	Public
End

Class Vector2D<T> Extends Vector<T>
	' Constant variables:
	Const INTERNAL_SIZE:Int = 2

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
		Super.New(INTERNAL_SIZE)
	End
		
	Method New(Size:Int)
		Super.New(Size)
	End
		
	Method New(Value:T[], CopyValue:Bool)
		Super.New(Value, CopyValue)
	End
	
	Method New(Value:T[], Size:Int=INTERNAL_SIZE, Offset:Int=XPOS)
		Super.New(Value, Size, Offset)
	End
	
	Method New(V:Vector<T>, Size:Int=INTERNAL_SIZE, Offset:Int=XPOS)
		Super.New(V, Size, Offset)
	End
	
	Method New(X:T, Y:T, INTERNAL_SIZE:Int=Vector2D<T>.INTERNAL_SIZE)
		Super.New(INTERNAL_SIZE)
		
		Self.X = X
		Self.Y = Y
	End
	
	Method Clone:Vector<T>()
		Return CloneAs2D()
	End
	
	Method CloneAs2D:Vector2D<T>()
		Return New Vector2D<T>(Self)
	End
	
	' Methods:
	Method CrossProduct:Vector<T>(V:Vector<T>, VectorOutput:Vector<T>=Null)
		' Local variable(s):
		Local V2D:= Vector2D<T>(V)
		Local V2DOut:Vector2D<T>
		
		#If VECTOR_SAFETY
			If (V2D = Null) Then
				Return Null
			Endif
		#End
		
		#If VECTOR_SAFETY
			If (VectorOutput <> Null) Then
		#End
				V2DOut = Vector2D<T>(VectorOutput)
				
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
	
	Method CrossProduct2D:Vector2D<T>(V:Vector2D<T>, VectorOutput:Vector2D<T>=Null)
		If (VectorOutput = Null) Then
			VectorOutput = New Vector2D<T>(Self)
		Else
			VectorOutput.Copy(Self)
		Endif
		
		' Local variable(s):
		VectorOutput.X = VectorOutput.CrossProduct_2D(V)
		
		Return VectorOutput
	End
	
	Method CrossProduct_2D:T(V:Vector2D<T>, VData_Offset:Int=XPOS) Final
		Return CrossProduct_2D(V.Data, VData_Offset)
	End
	
	Method CrossProduct_2D:T(A:T[], A_Offset:Int=XPOS) Final
		' Local variable(s):
		Local REAL_X:= XPOS+A_Offset
		Local REAL_Y:= YPOS+A_Offset
		
		#If VECTOR_SAFETY
			If (OutOfBounds(Max(REAL_X, REAL_Y), A.Length)) Then
				Return NIL
			Endif
		#End
		
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return (InnerValue(X)*InnerValue(A[REAL_Y]) - InnerValue(Y)*InnerValue(A[REAL_X]))
		#Else
			Return (X*A[REAL_Y] - Y*A[REAL_X])
		#End
	End
	
	Method RotateTowards:Void(V:Vector2D<T>)
		Rotate(CrossProduct_2D(V))
		
		Return
	End
	
	Method Rotate:Void(Angle:T)
		Rotate_2D(Angle)
		
		Return
	End
	
	Method Rotate_2D:Void(Angle:T) Final
		' Local variable(s):
		Local Length:= Self.Length
		
		X = Length * Cos(Angle)
		Y = Length * Sin(Angle)
		
		Return
	End
	
	Method AngleTo:T(V:Vector2D<T>)
		Return AngleTo_2D(V)
	End
	
	Method AlternateAngleTo:T(V:Vector2D<T>)
		Return AlternateAngleTo_2D(V)
	End
	
	Method AngleTo_2D:T(V:Vector2D<T>) Final
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return InnerValue(HALF_FULL_ROTATION_IN_DEGREES) - ATan2(InnerValue(Y) - InnerValue(V.Y), InnerValue(X) - InnerValue(V.X))
		#Else
			Return HALF_FULL_ROTATION_IN_DEGREES - ATan2(Y - V.Y, X - V.X)
		#End
	End
	
	Method AlternateAngleTo_2D:T(V:Vector2D<T>) Final
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return ATan2(-(InnerValue(X) + InnerValue(V.X)), -(InnerValue(Y) + InnerValue(V.Y)))
		#Else
			Return ATan2(-(X + V.X), -(Y + V.Y))
		#End
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
		Local VectorOutput:= CloneAs2D()
		
		' Rotate the vector.
		VectorOutput.AsPerpendicular()
		
		' Return the output-vector.
		Return VectorOutput
	End
	
	Method ReversePerpendicular:Vector2D<T>()
		' Local variable(s):
		
		' Generate a new 2D vector.
		Local VectorOutput:= CloneAs2D()
		
		' Rotate the vector.
		VectorOutput.AsReversePerpendicular()
		
		' Return the output-vector.
		Return VectorOutput
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
		
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Self.X = -InnerValue(Y)
		#Else
			Self.X = -Y
		#End
		
		Self.Y = X
		
		Return
	End
	
	Method AsReversePerpendicular:Void()
		' Local variable(s):
		Local X:= Self.X
		
		Self.X = Y
		
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Self.Y = -InnerValue(X)
		#Else
			Self.Y = -X
		#End
		
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
	
	#If Not VECTOR_SHARE_OPTIMIZATIONS
		Method MakeBetween:Vector<T>(V:Vector<T>)
			Return MakeBetween2D(V)
		End
	#End
	
	Method MakeBetween2D:Vector2D<T>(V:Vector<T>)
		' Local variable(s):
		
		' Generate a new vector.
		Local VectorOutput:= CloneAs2D()
		
		VectorOutput.Subtract(V)
		
		' Return the output-vector.
		Return VectorOutput
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
		Return (Super.ToString() + ", Y: '" + String(Y) + "'")
	End
	
	' Properties:
	Method Angle:T() Property
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return InnerValue(HALF_FULL_ROTATION_IN_DEGREES) - ATan2(-InnerValue(Y), -InnerValue(X))
		#Else
			Return HALF_FULL_ROTATION_IN_DEGREES - ATan2(-Y, -X)
		#End
	End
	
	Method Angle:Void(Input:T) Property
		' Local variable(s):
		Local Length:= Self.Length
		
		X = Length * Cos(Input)
		Y = Length * -Sin(Input)
		
		Return
	End
	
	#Rem
		This property was mainly built to be used
		when drawing rotated images based on a vector.
		There are also several alternate versions of the
		angle/rotation oriented commands in this module.
		
		"Alternate" functionality is mostly untested,
		and should be used with a grain of salt.
		
		This functionality was added for my own internal purposes,
		and is subject to change at any time.
	#End
	
	Method AlternateAngle:T() Property
		Return ATan2(-X, -Y)
	End
	
	Method AlternateAngle:Void(Input:T) Property
		Local Length:= Self.Length
		
		X = Length * Sin(Input)
		Y = Length * Cos(Input)
		
		Return
	End
	
	' This property is mainly used for calculating ratios:
	Method Delta_1D:T() Property Final
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return (InnerValue(Y)-InnerValue(X))
		#Else
			Return (Y-X)
		#End
	End
	
	Method Distance_1D:T() Property Final
		Return AbsoluteNumber(Delta_1D)
	End
	
	Method Y:T() Property Final
		Return Data[YPOS]
	End
	
	Method Y:Void(Value:T) Property Final
		Data[YPOS] = Value
		
		Return
	End
	
	' Directional properties:
	Method Left:T() Property Final
		Return X
	End
	
	Method Left:Void(Value:T) Property Final
		X = Value
		
		Return
	End
	
	Method Right:T() Property Final
		Return Y
	End
	
	Method Right:Void(Value:T) Property Final
		Y(Value)
		
		Return
	End
End

Class Vector3D<T> Extends Vector2D<T>
	' Constant variables:
	Const INTERNAL_SIZE:Int = 3
	
	' Functions:
	Function Name:String()
		Return "Vector(3D)"
	End
	
	Function FromInts:Vector3D<T>(X:Int, Y:Int, Z:Int)
		Return New Vector3D<T>(T(X), T(Y), T(Z))
	End
	
	Function FromFloats:Vector3D<T>(X:Float, Y:Float, Z:Float)
		Return New Vector3D<T>(T(X), T(Y), T(Z))
	End
	
	' Constructor(s):
	Method New()
		Super.New(INTERNAL_SIZE)
	End
	
	Method New(Size:Int)
		Super.New(Size)
	End
	
	Method New(Value:T[], CopyValue:Bool)
		Super.New(Value, CopyValue)
	End
	
	Method New(Value:T[], Size:Int=INTERNAL_SIZE, Offset:Int=XPOS)
		Super.New(Value, Size, Offset)
	End
	
	Method New(V:Vector<T>, Size:Int=INTERNAL_SIZE, Offset:Int=XPOS)
		Super.New(V, Size, Offset)
	End
	
	Method New(X:T, Y:T, Z:T=NIL, INTERNAL_SIZE:Int=Vector3D<T>.INTERNAL_SIZE)
		Super.New(X, Y, INTERNAL_SIZE)
		
		Self.Z = Z
	End
	
	' Methods:
	Method Clone:Vector<T>()
		Return CloneAs3D()
	End
	
	Method CloneAs3D:Vector3D<T>()
		Return New Vector3D<T>(Self)
	End
	
	Method CrossProduct:Vector<T>(V:Vector<T>, VectorOutput:Vector<T>=Null)
		' Local variable(s):
		Local V3D:= Vector3D<T>(V)
		Local V3DOut:Vector3D<T>
		
		#If VECTOR_SAFETY
			If (V3D = Null) Then
				Return Null
			Endif
		#End
		
		#If VECTOR_SAFETY
			If (VectorOutput <> Null) Then
		#End
				V3DOut = Vector3D<T>(VectorOutput)
				
				#If VECTOR_SAFETY
					If (V3DOut = Null) Then
						Return Null
					Endif
				#End
		#If VECTOR_SAFETY
			Endif
		#End
		
		' Call the main implementation, then return its output.
		Return CrossProduct3D(V3D, V3DOut)
	End
	
	' If you're dealing with 'Vector3D' objects directly,
	' then you really should use this command over 'CrossProduct':
	Method CrossProduct3D:Vector3D<T>(V:Vector3D<T>, VectorOutput:Vector3D<T>=Null)
		If (VectorOutput = Null) Then
			VectorOutput = New Vector3D<T>(Self)
		Else
			VectorOutput.Copy(Self)
		Endif
		
		VectorOutput.CrossProduct_3D(V)
		
		Return VectorOutput
	End
	
	Method CrossProduct_3D:Void(V:Vector3D<T>) ' Final
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
	
	Method CrossProduct_3D:Void(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS) ' Final
		' Local variable(s):
		Local A_RawLength:= A.Length
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		If ((A_Length - A_Offset) < 3) Then
			Return
		Endif
		
		Local O:= A_Offset
		
		' Cache the internal-data locally:
		Local X:= Self.X
		Local Y:= Self.Y
		Local Z:= Self.Z
		
		' Calculate the product:
		Self.X = Y*A[O+ZPOS] - Z*A[O+YPOS]
		Self.Y = Z*A[O+XPOS] - X*A[O+ZPOS]
		Self.Z = X*A[O+YPOS] - Y*A[O+XPOS]
		
		Return
	End
	
	#If Not VECTOR_SHARE_OPTIMIZATIONS
		Method MakeBetween:Vector<T>(V:Vector<T>)
			Return MakeBetween3D(V)
		End
	#End
	
	Method MakeBetween3D:Vector3D<T>(V:Vector<T>)
		' Local variable(s):
		
		' Generate a new vector.
		Local VectorOutput:= CloneAs3D()
		
		VectorOutput.Subtract(V)
		
		' Return the output-vector.
		Return VectorOutput
	End
	
	Method RotateYawTowards:Void(V3D:Vector3D<T>)
		RotateTowards_3D(V3D)
		
		Return
	End
	
	Method RotateYawTowards:Void(V2D:Vector2D<T>)
		Local Product:= CrossProduct_2D(V2D)
		
		Rotate_2DIn3D(Cos(Product), Sin(Product))
		
		Return
	End
	
	Method Rotate:Void(Angle:T)
		Rotate_2DIn3D(Cos(Angle), Sin(Angle))
		
		Return
	End
	
	Method Rotate_2DIn3D:Void(V:Vector2D<T>) Final
		Rotate_2DIn3D(V.X, V.Y)
		
		Return
	End
	
	Method Rotate_2DIn3D:Void(RX:T, RY:T) Final
		Rotate_2DIn3D(RX, RY, Length)
		
		Return
	End
	
	Method Rotate_2DIn3D:Void(RX:T, RZ:T, Length:T) Final
		X = Length * RX
		Z = Length * RZ
		
		Return
	End
	
	Method Rotate_3D:Void(RX:T, RY:T, RZ:T) Final
		Rotate_3D(RX, RY, RZ, Length)
		
		Return
	End
	
	Method Rotate_3D:Void(RX:T, RY:T, RZ:T, Length:T) Final
		Rotate_2DIn3D(RX, RZ, Length)
		
		Y = Length * RY
		
		Return
	End
	
	Method Rotate_3D:Void(R:Vector3D<T>) Final
		Rotate_3D(R.X, R.Y, R.Z)
		
		Return
	End
	
	Method RotateTowards_3D:Void(V:Vector3D<T>, TempVector:Vector3D<T>=Null) Final
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
	
	Method AlternateAngleTo:T(V:Vector2D<T>)
		' Local variable(s):
		
		' Check if the input was a 'Vector3D'.
		Local V3D:= Vector3D<T>(V)
		
		If (V3D <> Null) Then
			Return AlternateAngleTo_3D(V3D)
		Endif
		
		Return AlternateAngleTo_2D(V)
	End
	
	Method AngleTo_3D:T(V:Vector3D<T>) Final
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return InnerValue(HALF_FULL_ROTATION_IN_DEGREES) - ATan2(InnerValue(Z) - InnerValue(V.Z), InnerValue(X) - InnerValue(V.X))
		#Else
			Return HALF_FULL_ROTATION_IN_DEGREES - ATan2(Z - V.Z, X - V.X)
		#End
	End
	
	Method AlternateAngleTo_3D:T(V:Vector3D<T>) Final
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return ATan2(-(InnerValue(Z) + InnerValue(V.Z)), -(InnerValue(X) + InnerValue(V.X)))
		#Else
			Return ATan2(-(Z + V.Z), -(X + V.X))
		#End
	End
	
	Method Normalized3D:Vector3D<T>(VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
		Return Normalized3D(Length(VData_Length, VData_Offset), VData_Length, VData_Offset, OutputVector)
	End
	
	Method Normalized3D:Vector3D<T>(Length:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS, OutputVector:Vector<T>=Null)
		' Call the main implementation.
		Return Vector3D<T>(Normalized(Length, VData_Length, VData_Offset, OutputVector))
	End
	
	Method ToString:String()
		Return (Super.ToString() + ", Z: '" + String(Z) + "'")
	End
	
	' Properties:
	Method Z:T() Property Final
		Return Data[ZPOS]
	End
	
	Method Z:Void(Value:T) Property Final
		Data[ZPOS] = Value
		
		Return
	End
	
	' Color properties:
	Method R:T() Property Final
		Return X
	End
	
	Method R:Void(Value:T) Property Final
		X = Value
		
		Return
	End
	
	Method G:T() Property Final
		Return Y
	End
	
	Method G:Void(Value:T) Property Final
		Y = Value
		
		Return
	End
	
	Method B:T() Property Final
		Return Z
	End
	
	Method B:Void(Value:T) Property Final
		Z = Value
		
		Return
	End
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
	Const INTERNAL_SIZE:Int = 4
	
	' Functions:
	Function Name:String()
		Return "Vector(4D)"
	End
	
	Function FromInts:Vector4D<T>(X:Int, Y:Int, Z:Int, W:Int)
		Return New Vector4D<T>(T(X), T(Y), T(Z), T(W))
	End
	
	Function FromFloats:Vector4D<T>(X:Float, Y:Float, Z:Float, W:Float)
		Return New Vector4D(T(X), T(Y), T(Z), T(W))
	End
	
	' Constructor(s):
	Method New()
		Super.New(INTERNAL_SIZE)
	End
	
	Method New(Size:Int)
		Super.New(Size)
	End
	
	Method New(Value:T[], CopyValue:Bool)
		Super.New(Value, CopyValue)
	End
	
	Method New(Value:T[], Size:Int=INTERNAL_SIZE, Offset:Int=XPOS)
		Super.New(Value, Size, Offset)
	End
	
	Method New(V:Vector<T>, Size:Int=INTERNAL_SIZE, Offset:Int=XPOS)
		Super.New(V, Size, Offset)
	End
	
	Method New(X:T, Y:T, Z:T=NIL, W:T=NIL, INTERNAL_SIZE:Int=Vector4D<T>.INTERNAL_SIZE)
		Super.New(X, Y, Z, INTERNAL_SIZE)
		
		Self.W = W
	End
	
	' Methods:
	Method Clone:Vector<T>()
		Return CloneAs4D()
	End
	
	Method CloneAs4D:Vector4D<T>()
		Return New Vector4D<T>(Self)
	End
	
	#If Not VECTOR_SHARE_OPTIMIZATIONS
		Method MakeBetween:Vector<T>(V:Vector<T>)
			Return MakeBetween4D(V)
		End
	#End
	
	Method MakeBetween4D:Vector4D<T>(V:Vector<T>)
		' Local variable(s):
		
		' Generate a new vector.
		Local VectorOutput:= CloneAs4D()
		
		VectorOutput.Subtract(V)
		
		' Return the output-vector.
		Return VectorOutput
	End
	
	Method ToString:String()
		Return (Super.ToString() + ", W: '" + String(W) + "'")
	End
	
	' Properties:
	Method W:T() Property Final
		Return Data[WPOS]
	End
	
	Method W:Void(Value:T) Property Final
		Data[WPOS] = Value
		
		Return
	End
	
	' Color properties:
	Method A:T() Property Final
		Return W
	End
	
	Method A:Void(Value:T) Property Final
		W = Value
		
		Return
	End
End