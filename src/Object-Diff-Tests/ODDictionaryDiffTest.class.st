Class {
	#name : #ODDictionaryDiffTest,
	#superclass : #TestCase,
	#category : #'Object-Diff-Tests'
}

{ #category : #tests }
ODDictionaryDiffTest >> test_dict_diff_string [
	| diff left right |
	left := Dictionary new.
	left at: 'firstKey' put: 'a'.
	left at: 'secondKey' put: 'b'.
	right := 'c'.
	diff := left diff: right.
	self assert: diff isNotNil.
	self assert: diff matches isEmpty.
	self assert: diff diffs isNotEmpty.
	self assert: (diff diffs at: 1) left equals: left.
	self assert: (diff diffs at: 1) right equals: right
]

{ #category : #tests }
ODDictionaryDiffTest >> test_diff_nil [
	| diff left |
	left := Dictionary new.
	left at: 'firstKey' put: 'a'.
	left at: 'secondKey' put: 'b'.
	diff := left diff: nil.
	self assert: diff isNotNil.
	self assert: diff matches isEmpty
]

{ #category : #tests }
ODDictionaryDiffTest >> test_diff_partially_matching_dictionaries [
	| diff left right |
	left := Dictionary new.
	left at: 'firstKey' put: 'a'.
	left at: 'secondKey' put: 'b'.
	right := Dictionary new.
	right at: 'firstKey' put: 'a'.
	right at: 'secondKey' put: 'c'.
	diff := left diff: right.
	self assert: diff isNotNil.
	self assert: diff diffs size equals: 1.
	self assert: (diff diffs at: 'secondKey') equals: ('b' diff: 'c').
	self assert: diff matches size equals: 1.
	self
		assert: (diff matches at: 'firstKey') equals: 'a'

]

{ #category : #tests }
ODDictionaryDiffTest >> test_identical [
	| diff value |
	value := Dictionary new.
	value at: 'firstKey' put: 'a'.
	value at: 'secondKey' put: 'b'.
	diff := value diff: value.
	self assert: diff isNotNil.
	self assert: diff diffs isEmpty.
	self
		assert: (diff matches at: 'firstKey')
		equals: 'a'.
	self
		assert: (diff matches at: 'secondKey') equals: 'b'.
	self assert: diff identical
]

{ #category : #tests }
ODDictionaryDiffTest >> test_printOn_identical [
	| diff value |
	value := Dictionary new.
	value at: 'firstKey' put: 'a'.
	value at: 'secondKey' put: 'b'.
	diff := value diff: value.
	self
		assert: diff greaseString
		equals: '[''firstKey''->''a'' ''secondKey''->''b'']'
]