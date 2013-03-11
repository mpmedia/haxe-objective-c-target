/**
 *  Used to generate a native selector in objc
 *  new SEL ( func )  -> @selector(func_signature)
 *  If the function has the @:sel metadata it will be used instead the function signature
 **/
extern class SEL {
	public function new (sel:Dynamic) :Void;
}