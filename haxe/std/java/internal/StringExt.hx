/*
 * Copyright (C)2005-2012 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package java.internal;
{
			if ( index >= me.length() || index < 0 )
	@:functionCode('
			if ( index >= me.length() || index < 0 )
	@:functionCode('
			int sIndex = (startIndex != null ) ? (haxe.lang.Runtime.toInt(startIndex)) : 0;
	@:functionCode('
			int sIndex = (startIndex != null ) ? (haxe.lang.Runtime.toInt(startIndex)) : (me.length() - 1);
	@:functionCode('
			Array<java.lang.String> ret = new Array<java.lang.String>();
			int slen = delimiter.length();
				while (pos >= 0)
					start = pos + slen;
				ret.push(me.substring(start));
	@:functionCode('
			int meLen = me.length();
			if( pos < 0 ){
			return me.substring(pos, pos + targetLen);
	@:functionCode('
		int endIdx;
		if ( startIndex < 0 ) {
		if ( startIndex > endIdx ) {
		return me.substring(startIndex, endIdx);
	')
	@:functionCode('
			return me.toLowerCase();
	@:functionCode('
			return me.toUpperCase();
	public static function toNativeString(me:NativeString):NativeString
	@:functionCode('
		return java.lang.Character.toString( (char) code );
{
	public static function handleGetField(str:NativeString, f:NativeString, throwErrors:Bool):Dynamic
	public static function handleCallField(str:NativeString, f:NativeString, args:Array<Dynamic>):Dynamic
		return Runtime.slowCallField(StringExt, f, args);
	function startsWith(prefix:String):Bool;