Class {
	#name : #ODArrayDiffTest,
	#superclass : #TestCase,
	#category : #'Object-Diff-Tests'
}

{ #category : #tests }
ODArrayDiffTest >> test_array_with_dictionary_diff_array_with_string [
	| diff left right nestedLeft nestedRight |
	left := Array new: 2.
	left atWrap: 1 put: 'a'.
	nestedLeft := Array new: 2.
	nestedLeft atWrap: 1 put: '1'.
	nestedLeft
		atWrap: 2
		put: (Dictionary with: 'd' -> 'D' with: 'e' -> 'E').
	left atWrap: 2 put: nestedLeft.
	right := Array new: 2.
	right atWrap: 1 put: 'a'.
	nestedRight := Array new: 2.
	nestedRight atWrap: 1 put: 'x'.
	nestedRight atWrap: 2 put: '2'.
	right atWrap: 2 put: nestedRight.
	diff := left diff: right.
	"[1:'a' 2:[1:'1' 2:['d'->'D' 'e'->'E']]]"
	"[1:'a' 2:[1:'x' 2:'2']]"
	self
		assert: diff greaseString
		equals: '[2:[1:''1'' 2:[''d''->''D'' ''e''->''E'']]~=[1:''x'' 2:''2'']]'
]

{ #category : #tests }
ODArrayDiffTest >> test_diff_nil [
	| diff left |
	left := Array new: 2.
	left atWrap: 1 put: 'a'.
	left atWrap: 2 put: 'b'.
	diff := left diff: nil.
	self assert: diff isNotNil.
	self assert: diff matches isEmpty
]

{ #category : #tests }
ODArrayDiffTest >> test_diff_partially_matching_arrays [
	| diff left right |
	left := Array new: 2.
	left atWrap: 1 put: 'a'.
	left atWrap: 2 put: 'b'.
	right := Array new: 2.
	right atWrap: 1 put: 'a'.
	right atWrap: 2 put: 'c'.
	diff := left diff: right.
	self assert: diff isNotNil.
	self assert: diff matches isNotEmpty.
	self assert: diff matches size equals: 1.
	self assert: diff matches first equals: 'a'.
	self assert: diff diffs isNotEmpty.
	self assert: diff diffs size equals: 1.
	self assert: diff diffs first equals: ('b' diff: 'c')
]

{ #category : #tests }
ODArrayDiffTest >> test_diff_with_nested_arrays [
	| diff left right nestedLeft nestedRight |
	left := Array new: 2.
	left atWrap: 1 put: 'a'.
	nestedLeft := #('1' '2').
	left atWrap: 2 put: nestedLeft.
	right := Array new: 2.
	right atWrap: 1 put: 'a'.
	nestedRight := #('x' '2').
	right atWrap: 2 put: nestedRight.
	diff := left diff: right.
	self assert: diff isNotNil.
	self assert: diff matches isNotEmpty.
	self assert: diff matches size equals: 1.
	self assert: diff matches first equals: 'a'.
	self assert: diff diffs isNotEmpty.
	self assert: diff diffs size equals: 1.
	self assert: diff diffs first equals: (nestedLeft diff: nestedRight)
]

{ #category : #tests }
ODArrayDiffTest >> test_identical [
	| diff left right |
	left := Array new: 2.
	left atWrap: 1 put: 'a'.
	left atWrap: 2 put: 'b'.
	right := Array new: 2.
	right atWrap: 1 put: 'a'.
	right atWrap: 2 put: 'b'.
	diff := left diff: right.
	self assert: diff isNotNil.
	self assert: diff matches isNotEmpty.
	self assert: diff matches size equals: 2.
	self assert: diff matches first equals: 'a'.
	self assert: diff matches second equals: 'b'.
	self assert: diff diffs isEmpty.
	self assert: diff identical
]

{ #category : #tests }
ODArrayDiffTest >> test_printOn_different [
	| diff left right |
	left := #('a').
	right := #('b').
	diff := left diff: right.
	self assert: diff greaseString equals: '[1:[''a''~=''b'']]'
]

{ #category : #tests }
ODArrayDiffTest >> test_printOn_identical [
	| diff value |
	value := #('a' 'b').
	diff := value diff: value.
	self assert: diff isNotNil.
	self assert: diff greaseString equals: '[1:''a'' 2:''b'']'
]

{ #category : #tests }
ODArrayDiffTest >> test_with_nested_dictionaries [
	| diff left right nestedLeft nestedRight |
	left := Array new: 2.
	left atWrap: 1 put: 'a'.
	nestedLeft := Array new: 2.
	nestedLeft atWrap: 1 put: '1'.
	nestedLeft
		atWrap: 2
		put: (Dictionary with: 'd' -> 'D' with: 'e' -> 'E').
	left atWrap: 2 put: nestedLeft.
	right := Array new: 2.
	right atWrap: 1 put: 'a'.
	nestedRight := Array new: 2.
	nestedRight atWrap: 1 put: 'x'.
	nestedRight atWrap: 2 put: '2'.
	right atWrap: 2 put: nestedRight.
	diff := left diff: right.
	self assert: diff isNotNil.
	self assert: diff matches isNotEmpty.
	self assert: diff matches size equals: 1.
	self assert: diff matches first equals: 'a'.
	self assert: diff diffs isNotEmpty.
	self assert: diff diffs size equals: 1.
	self assert: diff diffs first equals: (nestedLeft diff: nestedRight).
	self assert: diff diffs first left equals: nestedLeft.
	self assert: diff diffs first right equals: nestedRight
]