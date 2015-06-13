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
		
		* Most methods (Unless explicitly stated otherwise) will affect the vector they're used from.
		
		For example, the 'Add' command found in the 'AbstractVector' class does not produce a vector of any kind.
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
#VECTOR_GROW_ON_ACCESS = True
#VECTOR_ALLOW_EXACT_GROWTH = True
#VECTOR_SMART_GROW = True
#VECTOR_TOSTRING_USE_GENERIC_UTIL = False ' True
#VECTOR_LEGACY_NAME_STRINGS = False

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

' Determine which route should be used for class-name storage:
#If LANG = "cpp"
	#VECTOR_CONSTANT_NAME_STRINGS = False
#Else
	#VECTOR_CONSTANT_NAME_STRINGS = True
#End

#Rem
	These variables toggle specific checks which may improve
	program stability and sometimes, even performance.
	Unless you're seriously looking into debugging
	this module, don't bother changing these.
#End

#If CONFIG = "debug"
	#VECTOR_SAFETY = True
	#VECTOR_NUMBER_SAFETY = True
#Else
	#VECTOR_SAFETY = True ' False
	#VECTOR_NUMBER_SAFETY = False
#End

#Rem
	Alternate division can sometimes improve performance,
	the default state of this variable is "undefined".
	
	This means I may change the default state
	of this functionality at some point in the future.
#End

#If Not VECTOR_NUMBER_SAFETY And CONFIG = "release"
	#VECTOR_ALTERNATE_DIVISION = True
#Else
	#VECTOR_ALTERNATE_DIVISION = False
#End

' This is just a backup check:
#If Not VECTOR_NUMBER_SAFETY
	#Rem
		This functionality can potentially improve performance on some systems.
		Basically, if this is enabled, this module will negate numbers using multiplication.
		
		I do not currently recommend this strategy, as it's
		really just something the compiler should be handling.
	#End
	
	#VECTOR_ALTERNATE_NEGATE = False ' True
#End

' Imports (Public):

' ImmutableOctet:
Import boxutil
Import util
Import ioelement
Import sizeof

' Imports (Private):
Private

' BRL:
Import brl.stream

Public

' The following operations must be done in order to configure the module(s) imported afterword:
#If VECTOR_SUPPORTLAYER_TYPEFIXES
	' Enabling this could cause some performance and/or garbage-generation problems.
	#VECTOR_DELEGATE_SUPPORTLAYER = False
	
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
	
	#VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY = (BOXUTIL_IMPLEMENTED And Not VECTOR_DELEGATE_SUPPORTLAYER)
#End

' Imports (Other):
#If Not VECTOR_DELEGATE_SUPPORTLAYER
	Private
#End

Import supportlayer

#If Not VECTOR_DELEGATE_SUPPORTLAYER
	Public
#End

' Check which modules were implemented, then perform various operations accordingly:

' These checks are mainly for optional functionality:
#If BRL_STREAM_IMPLEMENTED
	' If this is enabled, the standard I/O methods will be implemented.
	#VECTOR_ALLOW_SERIALIZATION = True
#End

' Check if serialization was enabled, and if we were able to find the 'ioelement' module:
#If VECTOR_ALLOW_SERIALIZATION And IOELEMENT_IMPLEMENTED
	' If enabled, this will allow the standard vector implementation
	' to be compliant with the 'SerializableElement' interface.
	#VECTOR_SUPPORT_IOELEMENT = True
#End

' Check if we should support the 'sizeof' module:
#If SIZEOF_IMPLEMENTED
	#VECTOR_SUPPORT_SIZEOF = True
#End

' Global variable(s) (Public):
' Nothing so far.

' Global variable(s) (Private):
Private

' Class name-string instances:
#If Not VECTOR_CONSTANT_NAME_STRINGS
	Global AbstractVector_Name_Str:String = "Vector (Abstract)"
	Global Vector2D_Name_Str:String = "Vector(2D)"
	Global Vector3D_Name_Str:String = "Vector(3D)"
	Global Vector4D_Name_Str:String = "Vector(4D)"
	Global ManualVector_Name_Str:String = "Vector"
#End

Public

' Constant variable(s) (Public):
Const VECTOR_AUTO:= UTIL_AUTO

' Property data-positions:
Const VECTOR_XPOSITION:= 0
Const VECTOR_YPOSITION:= 1
Const VECTOR_ZPOSITION:= 2

' Constant variable(s) (Private):
Private

#If VECTOR_CONSTANT_NAME_STRINGS
	Const AbstractVector_Name_Str:String = "Vector (Abstract)"
	Const Vector2D_Name_Str:String = "Vector(2D)"
	Const Vector3D_Name_Str:String = "Vector(3D)"
	Const Vector4D_Name_Str:String = "Vector(4D)"
	Const ManualVector_Name_Str:String = "Vector"
#End

Public

' Interfaces:

#Rem
	There are a number of requirements for implementing a vector class.
	This interface shows exactly what those are.
	Any class following this interface can work with the standard implementation.
	
	This is also used by the standard vector classes
	as a nonspecific interface between each other.
	Such functionality may or may not be required by this interface.
	
	If you decide to implement this, please use this interface for commands
	in your own vector class, which do not need instances of that specific class.
#End

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
	
	Method DeltaSubtract:Void(V:Vector<T>, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method DeltaSubtract:Void(A:T[], Scalar:T, A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method DeltaSubtract:Void(F:T, Scalar:T, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
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
	Method Normalize:Void(Length:T, VData_Length:Int, VData_Offset:Int)
	
	Method IsNormalTo:Bool(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method IsNormalTo:Bool(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	
	Method IsEqualTo:Bool(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method IsEqualTo:Bool(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	
	Method Distance:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method Distance:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	
	' This is effectively an alias for 'Add'.
	' The return value is the amount possible. (Usually the same as the input)
	Method Offset:T(Amount:T)
	
	Method DotProduct:T(V:Vector<T>, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	Method DotProduct:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS)
	Method DotProductNormalized:T(V:Vector<T>)
	
	Method SubtractTowardsZero:Void(Time:T=AbstractVector<T>.ONE, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
	
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
	
	' This isn't based on default arguments due to issues with the type of 'T'.
	Method Length:T() Property
	
	Method Length:T(VData_Length:Int, VData_Offset:Int) Property
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
#If VECTOR_SUPPORT_IOELEMENT
Class AbstractVector<T> Implements Vector<T>, SerializableElement
#Else
Class AbstractVector<T> Implements Vector<T>
#End
	' Constant variable(s):
	
	' The position of the 'X' property.
	Const XPOS:= Vector<T>.XPOS
	
	' The size of this vector-type.
	Const VECTORSIZE:Int = 1
	
	' General:
	Const AUTO:= VECTOR_AUTO
	
	' Error template(s):
	Const VECTOR_GENERIC_ERROR_TEMPLATE:String = "{VECTOR} {ERROR}: "
	
	' Defaults:
	Const Default_ExactGrowthThreshold:Int = 16
	
	' Boleans / Flags:
	Const Default_ToString_FixErrors:Bool = True
	
	' Global variable(s):
	
	' The default value of the type specified.
	Global NIL:T
	
	#If VECTOR_LEGACY_NAME_STRINGS
		' The name of this class.
		Global Name_Str:= AbstractVector_Name_Str
	#End
	
	#If VECTOR_ZERO_WITH_NIL
		Global ZERO:= NIL
	#Else
		Global ZERO:= T(0)
	#End
	
	Global ONE:= T(1)
	Global TWO:= T(2)
	
	Global FULL_ROTATION_IN_DEGREES:T = T(360)
	Global HALF_FULL_ROTATION_IN_DEGREES:T = T(180.0)
	
	' Defaults:
	
	' The default multiplier used for container growth.
	Global Default_GrowthMultiplier:Float = 1.5 ' 2.0
	
	' Booleans / Flags:
	
	' This represents the default auto-grow flag for all vector classes for the current type ('T').
	Global Default_AutoGrow:Bool = False
	
	' Functions:
	Function Name:String()
		#If VECTOR_LEGACY_NAME_STRINGS
			Return Name_Str
		#Else
			Return AbstractVector_Name_Str
		#End
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
		Return New AbstractVector<T>(Self)
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
			Data[I] = AbsoluteNumber(Data[I])
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
		Local VData_RawLength:= Data.Length()
		
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
		Local VData_RawLength:= Data.Length()
		
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
		Local VData_RawLength:= Data.Length()
		
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
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
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
		Local VData_RawLength:= Data.Length()
		
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
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
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
		Local VData_RawLength:= Data.Length()
		
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
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
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
		Local VData_RawLength:= Data.Length()
		
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
		Local VData_RawLength:= Data.Length()
		
		If (VData_Length = AUTO) Then
			VData_Length = VData_RawLength
		Endif
		
		Local VelocityLength:= Length()
		
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
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
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
		Local VData_RawLength:= Data.Length()
		
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
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			#If Not VECTOR_ALTERNATE_DIVISION
				#If VECTOR_SUPPORTLAYER_TYPEFIXES
					Data[Index] = DivideNumber(Data[Index], A[Index])
				#Else
					Data[Index] /= A[Index]
				#End
			#Else
				' Local variable(s):
				#If Not VECTOR_SUPPORTLAYER_TYPEFIXES
					Local A_On_Index:= A[Index]
				#Else
					Local A_On_Index:= InnerValue(A[Index])
				#End
				
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
				#If VECTOR_SUPPORTLAYER_TYPEFIXES
					Data[Index] = DivideNumber(Data[Index], F)
				#Else
					Data[Index] /= F
				#End
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
		Local VData_RawLength:= Data.Length()
		
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
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		#If VECTOR_NUMBER_SAFETY
			t = ClampNumber(t, ZERO, ONE)
		#End
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
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
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				D += Pow(InnerValue(A[Index])-InnerValue(Data[Index]), TWO)
			#Else
				D += Pow(A[Index]-Data[Index], TWO)
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
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		Local Sum:T = NIL
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			#If VECTOR_SUPPORTLAYER_TYPEFIXES
				Sum += (InnerValue(Data[Index])*InnerValue(A[Index]))
			#Else
				Sum += Data[Index]*A[Index]
			#End
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
	
			Those temporary vectors should be either able to be resized when needed (The standard implementations here do this),
			or they'll need to be the same sizes as the associated vectors.
			
			* The 'V_Length' and 'V_Offset' arguments are referring to the 'V' argument.
			* The 'VData_Length' and 'VData_Offset' arguments are referring to the current vector (Self).
	#End
	
	Method DotProductNormalized:T(V:Vector<T>, FTV:Vector<T>, STV:Vector<T>, V_Length:Int=AUTO, V_Offset:Int=XPOS, VData_Length:Int=AUTO, VData_Offset:Int=XPOS)
		If (V_Length = AUTO) Then
			V_Length = V.Size
		Endif
		
		' Local variable(s):
		Local Size:= Min(Self.Size, V.Size)
		
		' Calculate the length and offset for 'STV':
		Local STV_Length:= Min(V_Length, Size)
		Local STV_Offset:= Min(V_Offset, Size)
		
		' Generate or mutate the two vectors:
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
		
		' Normalize the two vectors:
		FTV.Normalize(VData_Length, VData_Offset)
		STV.Normalize(STV_Length, STV_Offset)
		
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
	
	#If VECTOR_ALLOW_SERIALIZATION
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
	#End
	
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
	
	Method Length:T() Property
		Return Length(AUTO, XPOS)
	End
	
	Method Length:T(VData_Length:Int, VData_Offset:Int) Property
		Return Length(Self.Data, VData_Length, VData_Offset)
	End
	
	Method Length:T(A:T[], A_Length:Int=AUTO, A_Offset:Int=XPOS) Property
		' Local variable(s):
		Local A_RawLength:= A.Length()
		
		If (A_Length = AUTO) Then
			A_Length = A_RawLength
		Endif
		
		Local Sum:T = ZERO
		
		For Local Index:= A_Offset Until Min(Data.Length(), Min(A_RawLength, A_Length))
			#If Not VECTOR_SUPPORTLAYER_TYPEFIXES
				Sum += (A[Index]*A[Index]) ' Pow(A[Index], TWO)
			#Else
				Sum += Sq(A[Index])
			#End
		Next
		
		Return Sqrt(Sum)
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
		Return Data.Length()
	End
	
	Method Size:Void(Input:Int) Property
		If (AutoGrow) Then
			ControlledGrow(Input+1)
		Endif
		
		Return
	End
	
	#If VECTOR_SUPPORT_SIZEOF
		Method SizeInBytes:Int() Property
			Return (Size * sizeof.SizeOf(X))
		End
	#End
	
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
	
	#If VECTOR_LEGACY_NAME_STRINGS
		' The name of this class.
		Global Name_Str:= Vector2D_Name_Str
	#End

	' Functions:
	Function Name:String()
		#If VECTOR_LEGACY_NAME_STRINGS
			Return Name_Str
		#Else
			Return Vector2D_Name_Str
		#End
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
		Return New Vector2D<T>(Self)
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
	
	Method CrossProduct_2D:T(V:Vector2D<T>, VData_Offset:Int=XPOS) Final
		Return CrossProduct_2D(V.Data, VData_Offset)
	End
	
	Method CrossProduct_2D:T(A:T[], A_Offset:Int=XPOS) Final
		' Local variable(s):
		Local REAL_X:= XPOS+A_Offset
		Local REAL_Y:= YPOS+A_Offset
		
		#If VECTOR_SAFETY
			If (OutOfBounds(Max(REAL_X, REAL_Y), A.Length())) Then
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
		Local Length:= Self.Length()
		
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
		Local VOUT:= CloneAs2D()
		
		VOUT.Subtract(V)
		
		' Return the output-vector.
		Return VOUT
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
		#If VECTOR_SUPPORTLAYER_TYPEFIXES
			Return InnerValue(HALF_FULL_ROTATION_IN_DEGREES) - ATan2(-InnerValue(Y), -InnerValue(X))
		#Else
			Return HALF_FULL_ROTATION_IN_DEGREES - ATan2(-Y, -X)
		#End
	End
	
	Method Angle:Void(Input:T) Property
		' Local variable(s):
		Local Length:= Self.Length()
		
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
		Local Length:= Self.Length()
		
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
	
	#If VECTOR_LEGACY_NAME_STRINGS
		' The name of this class.
		Global Name_Str:= Vector3D_Name_Str
	#End
	
	' Functions:
	Function Name:String()
		#If VECTOR_LEGACY_NAME_STRINGS
			Return Name_Str
		#Else
			Return Vector3D_Name_Str
		#End
	End
	
	Function FromInts:Vector3D<T>(X:Int, Y:Int, Z:Int)
		Return New Vector3D<T>(T(X), T(Y), T(Z))
	End
	
	Function FromFloats:Vector3D<T>(X:Float, Y:Float, Z:Float)
		Return New Vector3D<T>(T(X), T(Y), T(Z))
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
		Return New Vector3D<T>(Self)
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
		
		' Call the main implementation, then return its output.
		Return CrossProduct3D(V3D, V3DOut)
	End
	
	' If you're dealing with 'Vector3D' objects directly,
	' then you really should use this command over 'CrossProduct':
	Method CrossProduct3D:Vector3D<T>(V:Vector3D<T>, VOUT:Vector3D<T>=Null)
		If (VOUT = Null) Then
			VOUT = New Vector3D<T>(Self)
		Else
			VOUT.Copy(Self)
		Endif
		
		VOUT.CrossProduct_3D(V)
		
		Return VOUT
	End
	
	Method CrossProduct_3D:Void(V:Vector3D<T>) Final
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
	
	#If Not VECTOR_SHARE_OPTIMIZATIONS
		Method MakeBetween:Vector<T>(V:Vector<T>)
			Return MakeBetween3D(V)
		End
	#End
	
	Method MakeBetween3D:Vector3D<T>(V:Vector<T>)
		' Local variable(s):
		
		' Generate a new vector.
		Local VOUT:= CloneAs3D()
		
		VOUT.Subtract(V)
		
		' Return the output-vector.
		Return VOUT
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
	
	Method Rotate_2DIn3D:Void(V:Vector2D<T>) Final
		Rotate_2DIn3D(V.X, V.Y)
		
		Return
	End
	
	Method Rotate_2DIn3D:Void(RX:T, RY:T) Final
		Rotate_2DIn3D(RX, RY, Length())
		
		Return
	End
	
	Method Rotate_2DIn3D:Void(RX:T, RZ:T, Length:T) Final
		X = Length * RX
		Z = Length * RZ
		
		Return
	End
	
	Method Rotate_3D:Void(RX:T, RY:T, RZ:T) Final
		Rotate_3D(RX, RY, RZ, Length())
		
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
	
	#If VECTOR_LEGACY_NAME_STRINGS
		' The name of this class.
		Global Name_Str:= Vector4D_Name_Str
	#End

	' Functions:
	Function Name:String()
		#If VECTOR_LEGACY_NAME_STRINGS
			Return Name_Str
		#Else
			Return Vector4D_Name_Str
		#End
	End
	
	Function FromInts:Vector4D<T>(A:Int, B:Int, C:Int, D:Int)
		Return New Vector4D<T>(T(A), T(B), T(C), T(D))
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
		Local VOUT:= CloneAs4D()
		
		VOUT.Subtract(V)
		
		' Return the output-vector.
		Return VOUT
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
	
	#If VECTOR_LEGACY_NAME_STRINGS
		' The name of this class.
		Global Name_Str:= ManualVector_Name_Str
	#End
	
	' Functions:
	Function Name:String()
		#If VECTOR_LEGACY_NAME_STRINGS
			Return Name_Str
		#Else
			Return ManualVector_Name_Str
		#End
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
		Return New ManualVector<T>(Self)
	End
	
	#If Not VECTOR_SHARE_OPTIMIZATIONS
		Method MakeBetween:Vector<T>(V:Vector<T>)
			Return MakeBetweenManualVectors(V)
		End
	#End
	
	Method MakeBetweenManualVectors:ManualVector<T>(V:Vector<T>)
		' Local variable(s):
		
		' Generate a new vector.
		Local VOUT:= CloneAsManualVector()
		
		VOUT.Subtract(V)
		
		' Return the output-vector.
		Return VOUT
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