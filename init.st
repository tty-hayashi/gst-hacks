String extend [

    fileIn [
	FileStream fileIn: self
    ]
    
    fileInPackage [
	PackageLoader fileInPackage: self asSymbol
    ]

    impls [
	| col symbol |
	symbol := self asSymbol.
	col := SortedCollection 
		    sortBlock: [:a :b | a displayString <= b displayString].
	Class allSubclassesDo: [:meta | 
	    (meta includesSelector: symbol) ifTrue: [col add: meta >> symbol].
	    (meta instanceClass includesSelector: symbol) ifTrue: [col add: meta instanceClass >> symbol]].
	^col
    ]

    sends [
	| col symbol |
	symbol := self asSymbol.
	col := SortedCollection 
		    sortBlock: [:a :b | a displayString <= b displayString].
	Class allSubclassesDo: 
		[:meta | 
		(meta whichSelectorsReferTo: symbol) do: [:sel | col add: meta >> sel].
		(meta instanceClass whichSelectorsReferTo: symbol) 
		    do: [:sel | col add: meta instanceClass >> sel]].
	^col
    ]
]

Class extend [
    refs [
	| methods assoc |
	methods := SortedCollection sortBlock: [:a :b | a displayString <= b displayString].
	assoc := self environment associationAt: self name asSymbol.
	CompiledMethod 
	    allInstancesDo: [:method | (method refersTo: assoc) ifTrue: [methods add: method]].
	^methods
    ]
    
    instVarReads: aString [
	| methods assoc |
	methods := SortedCollection sortBlock: [:a :b | a displayString <= b displayString].
	self withAllSubclassesDo: 
		[:meta | 
		(meta whichSelectorsRead: aString) do: [:sel | methods add: meta >> sel]].
	^methods
    ]

    instVarWrites: aString [
	| methods assoc |
	methods := SortedCollection sortBlock: [:a :b | a displayString <= b displayString].
	self withAllSubclassesDo: 
		[:meta | 
		(meta whichSelectorsAssign: aString) do: [:sel | methods add: meta >> sel]].
	^methods
    ]

    instVarRefs: aString [
	| methods assoc |
	methods := SortedCollection sortBlock: [:a :b | a displayString <= b displayString].
	self withAllSubclassesDo: 
		[:meta | 
		(meta whichSelectorsAccess: aString) do: [:sel | methods add: meta >> sel]].
	^methods
    ]

    refsTo: anObject [
	| methods assoc |
	methods := SortedCollection sortBlock: [:a :b | a displayString <= b displayString].
	self withAllSubclassesDo: 
		[:meta | 
		(meta whichSelectorsReferTo: anObject) do: [:sel | methods add: meta >> sel]].
	^methods
    ]
]

CompiledMethod extend [
    src [
	^self methodSourceString
    ]
]
