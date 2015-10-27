Strict

Public

#Rem
	DESCRIPTION:
		* This file contains all of the "abstracted" routines used within the 'vector' module.
		
		Basically, this contains work arounds for types which have problems being used in specific ways.
		For example, at the time of writing this, support for the standard "box" classes needs to be explicit.
		
		This layer can be opened up via the preprocessor using 'vector', or imported separately.
#End

' Imports:
Import regal.vector

#If VECTOR_SUPPORTLAYER_TYPEFIXES
	Import regal.boxutil
#End

' Aliases:
#If Not VECTOR_SUPPORTLAYER_TYPEFIXES
	Alias AbsoluteNumber = Abs
	Alias MinimumNumber = Min
	Alias MaximumNumber = Max
	Alias ClampNumber = Clamp
#End

' Functions:

' Mandatory commands:
Function NegateNumber:Int(I:Int)
	#If Not VECTOR_ALTERNATE_NEGATE
		Return -I
	#Else
		Return I * -1
	#End
End

Function NegateNumber:Float(F:Float)
	#If Not VECTOR_ALTERNATE_NEGATE
		Return -F
	#Else
		Return F * -1.0
	#End
End

#If Not MONKEYLANG_EXPLICIT_BOXES
	' The following implementations are for optimization as well as overall support:
	Function NegateNumber:IntObject(IO:IntObject)
		#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
			IO.value = NegateNumber(IO.ToInt()) ' IO.value
			
			Return IO
		#Else
			Return New IntObject(NegateNumber(IO.ToInt()))
		#End
	End
	
	Function NegateNumber:FloatObject(FO:FloatObject)
		#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
			FO.value = NegateNumber(FO.ToFloat()) ' FO.value
			
			Return FO
		#Else
			Return New FloatObject(NegateNumber(FO.ToFloat()))
		#End
	End
#End

' Optional commands:
#If VECTOR_SUPPORTLAYER_TYPEFIXES
	#Rem
		DESCRIPTION:
			* The following commands were created to solve auto-conversion conflicts with the standard "box" classes.
			Commands that are enclosed with preprocessor checks relating to auto-conversion are a formality.
			
			That being said, if a command takes a standard "box" class,
			and isn't enclosed by such checks, it's needed no matter the situation.
	#End
	
	Function AddNumbers:Int(FirstNumber:Int, SecondNumber:Int)
		Return FirstNumber + SecondNumber
	End
	
	Function AddNumbers:Float(FirstNumber:Float, SecondNumber:Float)
		Return FirstNumber + SecondNumber
	End
	
	#If Not MONKEYLANG_EXPLICIT_BOXES
		Function AddNumbers:IntObject(IO:IntObject, Amount:IntObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				IO.value += Amount.ToInt()
				
				Return IO
			#Else
				Return New IntObject(IO.ToInt() + Amount.ToInt())
			#End
		End
		
		Function AddNumbers:FloatObject(FO:FloatObject, Amount:FloatObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				FO.value += Amount.ToFloat()
				
				Return FO
			#Else
				Return New FloatObject(FO.ToFloat() + Amount.ToFloat())
			#End
		End
	#End
	
	Function DeltaAddNumbers:Int(FirstNumber:Int, SecondNumber:Int, Scalar:Int)
		Return FirstNumber + (SecondNumber * Scalar)
	End
	
	Function DeltaAddNumbers:Float(FirstNumber:Float, SecondNumber:Float, Scalar:Float)
		Return FirstNumber + (SecondNumber * Scalar)
	End
	
	Function DeltaSubtractNumbers:Int(FirstNumber:Int, SecondNumber:Int, Scalar:Int)
		Return FirstNumber - (SecondNumber * Scalar)
	End
	
	Function DeltaSubtractNumbers:Float(FirstNumber:Float, SecondNumber:Float, Scalar:Float)
		Return FirstNumber - (SecondNumber * Scalar)
	End
	
	#If Not MONKEYLANG_EXPLICIT_BOXES
		Function DeltaAddNumbers:IntObject(IO:IntObject, Amount:IntObject, Scalar:IntObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				IO.value += (Amount.ToInt() * Scalar.ToInt())
				
				Return IO
			#Else
				Return New IntObject(IO.ToInt() + (Amount.ToInt() * Scalar.ToInt()))
			#End
		End
		
		Function DeltaAddNumbers:FloatObject(FO:FloatObject, Amount:FloatObject, Scalar:FloatObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				FO.value += (Amount.ToFloat() * Scalar.ToFloat())
				
				Return FO
			#Else
				Return New FloatObject(FO.ToFloat() + (Amount.ToFloat() * Scalar.ToFloat()))
			#End
		End
		
		Function DeltaSubtractNumbers:IntObject(IO:IntObject, Amount:IntObject, Scalar:IntObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				IO.value -= (Amount.ToInt() * Scalar.ToInt())
				
				Return IO
			#Else
				Return New IntObject(IO.ToInt() - (Amount.ToInt() * Scalar.ToInt()))
			#End
		End
		
		Function DeltaSubtractNumbers:FloatObject(FO:FloatObject, Amount:FloatObject, Scalar:FloatObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				FO.value -= (Amount.ToFloat() * Scalar.ToFloat())
				
				Return FO
			#Else
				Return New FloatObject(FO.ToFloat() - (Amount.ToFloat() * Scalar.ToFloat()))
			#End
		End
	#End
	
	Function SubtractNumber:Int(FirstNumber:Int, SecondNumber:Int)
		Return FirstNumber - SecondNumber
	End
	
	Function SubtractNumber:Float(FirstNumber:Float, SecondNumber:Float)
		Return FirstNumber - SecondNumber
	End
	
	#If Not MONKEYLANG_EXPLICIT_BOXES
		Function SubtractNumber:IntObject(IO:IntObject, Amount:IntObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				IO.value -= Amount.ToInt()
				
				Return IO
			#Else
				Return New IntObject(IO.ToInt() - Amount.ToInt())
			#End
		End
		
		Function SubtractNumber:FloatObject(FO:FloatObject, Amount:FloatObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				FO.value -= Amount.ToFloat()
				
				Return FO
			#Else
				Return New FloatObject(FO.ToFloat() - Amount.ToFloat())
			#End
		End
	#End
	
	Function MultiplyNumbers:Int(FirstNumber:Int, SecondNumber:Int)
		Return FirstNumber * SecondNumber
	End
	
	Function MultiplyNumbers:Float(FirstNumber:Float, SecondNumber:Float)
		Return FirstNumber * SecondNumber
	End
	
	#If Not MONKEYLANG_EXPLICIT_BOXES
		Function MultiplyNumbers:IntObject(IO:IntObject, Scalar:IntObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				IO.value *= Scalar.ToInt()
				
				Return IO
			#Else
				Return New IntObject(IO.ToInt() * Scalar.ToInt())
			#End
		End
		
		Function MultiplyNumbers:FloatObject(FO:FloatObject, Scalar:FloatObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				FO.value *= Scalar.ToFloat()
				
				Return FO
			#Else
				Return New FloatObject(FO.ToFloat() * Scalar.ToFloat())
			#End
		End
	#End
	
	Function DivideNumber:Int(FirstNumber:Int, SecondNumber:Int)
		Return FirstNumber / SecondNumber
	End
	
	Function DivideNumber:Float(FirstNumber:Float, SecondNumber:Float)
		Return FirstNumber / SecondNumber
	End
	
	#If Not MONKEYLANG_EXPLICIT_BOXES
		Function DivideNumber:IntObject(IO:IntObject, Divisor:IntObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				IO.value /= Divisor.ToInt()
				
				Return IO
			#Else
				Return New IntObject(IO.ToInt() / Divisor.ToInt())
			#End
		End
		
		Function DivideNumber:FloatObject(FO:FloatObject, Divisor:FloatObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				FO.value /= Divisor.ToFloat()
				
				Return FO
			#Else
				Return New FloatObject(FO.ToFloat() / Divisor.ToFloat())
			#End
		End
	#End
	
	Function AbsoluteNumber:Int(I:Int)
		Return Abs(I)
	End
	
	Function AbsoluteNumber:Float(F:Float)
		Return Abs(F)
	End
	
	#If Not MONKEYLANG_EXPLICIT_BOXES
		Function AbsoluteNumber:IntObject(IO:IntObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				IO.value = AbsoluteNumber(IO.ToInt()) ' IO.value
				
				Return IO
			#Else
				Return New IntObject(AbsoluteNumber(IO.ToInt()))
			#End
		End
		
		Function AbsoluteNumber:FloatObject(FO:FloatObject)
			#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				FO.value = AbsoluteNumber(FO.ToFloat()) ' FO.value
				
				Return FO
			#Else
				Return New FloatObject(AbsoluteNumber(FO.ToFloat()))
			#End
		End
	#End
	
	Function MinimumNumber:Int(X:Int, Y:Int)
		Return Min(X, Y)
	End
	
	Function MinimumNumber:Float(X:Float, Y:Float)
		Return Min(X, Y)
	End
	
	' The following implementations are for optimization as well as overall support:
	Function MinimumNumber:IntObject(X:IntObject, Y:IntObject)
		If (X.ToInt() < Y.ToInt()) Then
			#If Not VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				Return CloneBox(X)
			#Else
				Return X
			#End
		Endif
		
		#If Not VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
			Return CloneBox(Y)
		#Else
			Return Y
		#End
	End
	
	Function MinimumNumber:FloatObject(X:FloatObject, Y:FloatObject)
		If (X.ToFloat() < Y.ToFloat()) Then
			#If Not VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				Return CloneBox(X)
			#Else
				Return X
			#End
		Endif
		
		#If Not VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
			Return CloneBox(Y)
		#Else
			Return Y
		#End
	End
	
	Function MaximumNumber:Int(X:Int, Y:Int)
		Return Max(X, Y)
	End
	
	Function MaximumNumber:Float(X:Float, Y:Float)
		Return Max(X, Y)
	End
	
	' The following implementations are for optimization as well as overall support:
	Function MaximumNumber:IntObject(X:IntObject, Y:IntObject)
		If (X.ToInt() > Y.ToInt()) Then
			#If Not VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				Return CloneBox(X)
			#Else
				Return X
			#End
		Endif
		
		#If Not VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
			Return CloneBox(Y)
		#Else
			Return Y
		#End
	End
	
	Function MaximumNumber:FloatObject(X:FloatObject, Y:FloatObject)
		If (X.ToFloat() > Y.ToFloat()) Then
			#If Not VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
				Return CloneBox(X)
			#Else
				Return X
			#End
		Endif
		
		#If Not VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
			Return CloneBox(Y)
		#Else
			Return Y
		#End
	End
	
	Function ClampNumber:Int(X:Int, Min:Int, Max:Int)
		Return Clamp(X, Min, Max)
	End
	
	Function ClampNumber:Float(X:Float, Min:Float, Max:Float)
		Return Clamp(X, Min, Max)
	End
	
	' The following implementations are for optimization as well as overall support:
	Function ClampNumber:IntObject(X:IntObject, Min:IntObject, Max:IntObject)
		#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
			X.value = ClampNumber(X.ToInt(), Min.ToInt(), Max.ToInt())
			
			Return X
		#Else
			Return New IntObject(ClampNumber(X.ToInt(), Min.ToInt(), Max.ToInt()))
		#End
	End
	
	Function ClampNumber:FloatObject(X:FloatObject, Min:FloatObject, Max:FloatObject)
		#If VECTOR_SUPPORTLAYER_OVEROPTIMIZE_MEMORY
			X.value = ClampNumber(X.ToFloat(), Min.ToFloat(), Max.ToFloat())
			
			Return X
		#Else
			Return New FloatObject(ClampNumber(X.ToFloat(), Min.ToFloat(), Max.ToFloat()))
		#End
	End
#End