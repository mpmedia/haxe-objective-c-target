
namespace haxe.lang
{
	public  class Runtime 
	{
		
	public static object getField(haxe.lang.HxObject obj, string field, int fieldHash, bool throwErrors)
	{
		if (obj == null && !throwErrors) return null;
		return obj.__hx_getField(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, throwErrors, false, false);
	}

	public static double getField_f(haxe.lang.HxObject obj, string field, int fieldHash, bool throwErrors)
	{
		if (obj == null && !throwErrors) return 0.0;
		return obj.__hx_getField_f(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, throwErrors, false);
	}

	public static object setField(haxe.lang.HxObject obj, string field, int fieldHash, object value)
	{
		return obj.__hx_setField(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, value, false);
	}

	public static double setField_f(haxe.lang.HxObject obj, string field, int fieldHash, double value)
	{
		return obj.__hx_setField_f(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, value, false);
	}

	public static object callField(haxe.lang.HxObject obj, string field, int fieldHash, Array args)
	{
		return obj.__hx_invokeField(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, args);
	}
		static Runtime() 
		{
			global::haxe.lang.Runtime.undefined = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{}), new global::Array<object>(new object[]{}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
		}
		public static  object undefined;
		
		public static   object closure(object obj, int hash, string field)
		{
			
		return new haxe.lang.Closure(obj, field, hash);
	
		}
		
		
		public static   bool eq(object v1, object v2)
		{
			
			if (System.Object.ReferenceEquals(v1, v2))
				return true;
			if (v1 == null || v2 == null)
				return false;

			System.IConvertible v1c = v1 as System.IConvertible;

			if (v1c != null)
			{
				System.IConvertible v2c = v2 as System.IConvertible;

				if (v2c == null)
				{
					return false;
				}

				System.TypeCode t1 = v1c.GetTypeCode();
				System.TypeCode t2 = v2c.GetTypeCode();
				if (t1 == t2)
					return v1c.Equals(v2c);

				switch(t1)
				{
					case System.TypeCode.Int64:
					case System.TypeCode.UInt64:
						return v1c.ToUInt64(null) == v2c.ToUInt64(null);
					default:
						return v1c.ToDouble(null) == v2c.ToDouble(null);
				}
			}

			System.ValueType v1v = v1 as System.ValueType;
			if (v1v != null)
			{
				return v1.Equals(v2);
			} else {
				System.Type v1t = v1 as System.Type;
				if (v1t != null)
				{
					System.Type v2t = v2 as System.Type;
					if (v2t != null)
						return typeEq(v1t, v2t);
					return false;
				}
			}

			return false;
	
		}
		
		
		public static   bool refEq(object v1, object v2)
		{
			
			if (v1 is System.Type)
				return typeEq(v1 as System.Type, v2 as System.Type);
			return System.Object.ReferenceEquals(v1, v2);
	
		}
		
		
		public static   double toDouble(object obj)
		{
			
		return (obj == null) ? 0.0 : (obj is double) ? (double)obj : ((System.IConvertible) obj).ToDouble(null);
	
		}
		
		
		public static   int toInt(object obj)
		{
			
		return (obj == null) ? 0 : (obj is int) ? (int)obj : ((System.IConvertible) obj).ToInt32(null);
	
		}
		
		
		public static   bool isInt(object obj)
		{
			
			System.IConvertible cv1 = obj as System.IConvertible;
			if (cv1 != null)
			{
                switch (cv1.GetTypeCode())
                {
                    case System.TypeCode.Double:
                        double d = (double)obj;

				        return d >= int.MinValue && d <= int.MaxValue && d == ( (int)d );
                    case System.TypeCode.UInt32:
                    case System.TypeCode.Int32:
                        return true;
                    default:
                        return false;
                }

			}
			return false;
	
		}
		
		
		public static   int compare(object v1, object v2)
		{
			
			System.IConvertible cv1 = v1 as System.IConvertible;
			if (cv1 != null)
			{
				System.IConvertible cv2 = v2 as System.IConvertible;

				if (cv2 == null)
				{
					throw new System.ArgumentException("Cannot compare " + v1.GetType().ToString() + " and " + v2.GetType().ToString());
				}

				switch(cv1.GetTypeCode())
				{
					case System.TypeCode.String:
						if (cv2.GetTypeCode() != System.TypeCode.String)
							throw new System.ArgumentException("Cannot compare " + v1.GetType().ToString() + " and " + v2.GetType().ToString());
						return v1.ToString().CompareTo(v2);
					/*case System.TypeCode.Int64:
					case System.TypeCode.UInt64:
						return ((int) (cv1.ToUInt64() - cv2.ToUInt64())) no Int64 operator support */
					case System.TypeCode.Double:
					double d1 = (double) v1;
					double d2 = cv2.ToDouble(null);

					if (double.IsInfinity(d1) || double.IsInfinity(d2))
						return (d1 < d2) ? -1 : (d1 > d2) ? 1 : 0;
					else
						return (int) (d1 - d2);
					default:
						return ((int) (cv1.ToDouble(null) - cv2.ToDouble(null)));
				}
			}

			System.IComparable c1 = v1 as System.IComparable;
			System.IComparable c2 = v2 as System.IComparable;

			if (c1 == null || c2 == null)
			{
				if (c1 == c2)
					return 0;

				throw new System.ArgumentException("Cannot compare " + v1.GetType().ToString() + " and " + v2.GetType().ToString());
			}

			return c1.CompareTo(c2);
	
		}
		
		
		public static   object plus(object v1, object v2)
		{
			
			if (v1 is string || v2 is string)
				return Std.@string(v1) + Std.@string(v2);

			System.IConvertible cv1 = v1 as System.IConvertible;
			if (cv1 != null)
			{
				System.IConvertible cv2 = v2 as System.IConvertible;

				if (cv2 == null)
				{
					throw new System.ArgumentException("Cannot dynamically add " + v1.GetType().ToString() + " and " + v2.GetType().ToString());
				}

				return cv1.ToDouble(null) + cv2.ToDouble(null);
			}

			throw new System.ArgumentException("Cannot dynamically add " + v1 + " and " + v2);
	
		}
		
		
		public static   object slowGetField(object obj, string field, bool throwErrors)
		{
			

		if (obj == null)
			if (throwErrors)
				throw new System.NullReferenceException("Cannot access field '" + field + "' of null.");
			else
				return null;

		System.Type t = obj as System.Type;
		System.Reflection.BindingFlags bf;
        if (t == null)
		{
			string s = obj as string;
			if (s != null)
				return haxe.lang.StringRefl.handleGetField(s, field, throwErrors);
			t = obj.GetType();
			bf = System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.FlattenHierarchy;
		} else {
			if (obj == typeof(string) && field.Equals("fromCharCode"))
				return new haxe.lang.Closure(typeof(haxe.lang.StringExt), field, 0);

			obj = null;
			bf = System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public;
		}

		System.Reflection.FieldInfo f = t.GetField(field, bf);
		if (f != null)
		{
			return haxe.lang.Runtime.unbox(f.GetValue(obj));
		} else {
			System.Reflection.PropertyInfo prop = t.GetProperty(field, bf);
			if (prop == null)
			{
				System.Reflection.MemberInfo[] m = t.GetMember(field, bf);
				if (m.Length > 0)
				{
					return new haxe.lang.Closure(obj != null ? obj : t, field, 0);
				} else {
					if (throwErrors)
						throw HaxeException.wrap("Cannot access field '" + field + "'.");
					else
						return null;
				}
			}
			return haxe.lang.Runtime.unbox(prop.GetValue(obj, null));
		}

	
		}
		
		
		public static   bool slowHasField(object obj, string field)
		{
			
		if (obj == null) return false;
		System.Type t = obj as System.Type;
		System.Reflection.BindingFlags bf;
        if (t == null)
		{
			string s = obj as string;
			if (s != null)
				return haxe.lang.StringRefl.handleGetField(s, field, false) != null;
			t = obj.GetType();
			bf = System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.FlattenHierarchy;
		} else {
			if (t == typeof(string))
				return field.Equals("fromCharCode");
			obj = null;
			bf = System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public;
		}

		System.Reflection.MemberInfo[] mi = t.GetMember(field, bf);
		return mi != null && mi.Length > 0;
	
		}
		
		
		public static   object slowSetField(object obj, string field, object @value)
		{
			
		if (obj == null)
			throw new System.NullReferenceException("Cannot access field '" + field + "' of null.");

		System.Type t = obj as System.Type;
		System.Reflection.BindingFlags bf;
        if (t == null)
		{
			t = obj.GetType();
			bf = System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.FlattenHierarchy;
		} else {
			obj = null;
			bf = System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public;
		}

		System.Reflection.FieldInfo f = t.GetField(field, bf);
		if (f != null)
		{
			if (f.FieldType.ToString().StartsWith("haxe.lang.Null"))
			{
				@value = haxe.lang.Runtime.mkNullable(@value, f.FieldType);
			}

			f.SetValue(obj, @value);
			return @value;
		} else {
			System.Reflection.PropertyInfo prop = t.GetProperty(field, bf);
			if (prop == null)
			{
				throw haxe.lang.HaxeException.wrap("Field '" + field + "' not found for writing from Class " + t);
			}

			if (prop.PropertyType.ToString().StartsWith("haxe.lang.Null"))
			{
				@value = haxe.lang.Runtime.mkNullable(@value, prop.PropertyType);
			}
			prop.SetValue(obj, @value, null);

			return @value;
		}

	
		}
		
		
		public static   object callMethod(object obj, global::System.Reflection.MethodBase[] methods, int methodLength, global::Array args)
		{
			unchecked 
			{
				int length = ((int) (global::haxe.lang.Runtime.getField_f(args, "length", 520590566, true)) );
				object[] oargs = new object[length];
				global::System.Type[] ts = new global::System.Type[length];
				{
					int _g = 0;
					while (( _g < ((int) (length) ) ))
					{
						int i = _g++;
						oargs[i] = args[i];
						if (( ! (( args[i] == default(object) )) )) 
						{
							ts[i] = global::cs.Lib.nativeType(args[i]);
						}
						
					}
					
				}
				
				int last = 0;
				if (( methodLength > 1 )) 
				{
					{
						int _g1 = 0;
						while (( _g1 < methodLength ))
						{
							int i1 = _g1++;
							global::System.Reflection.ParameterInfo[] @params = methods[i1].GetParameters();
							if (( @params.Length != length )) 
							{
								continue;
							}
							 else 
							{
								bool fits = true;
								{
									int _g2 = 0;
									int _g11 = @params.Length;
									while (( _g2 < _g11 ))
									{
										int i2 = _g2++;
										global::System.Type param = @params[i2].ParameterType;
										string strParam = global::haxe.lang.Runtime.concat(global::Std.@string(param), "");
										if (( strParam.StartsWith("haxe.lang.Null") || ( (( ( oargs[i2] == default(object) ) || ( oargs[i2] is global::System.IConvertible ) )) && (((global::System.Type) (typeof(global::System.IConvertible)) )).IsAssignableFrom(param) ) )) 
										{
											continue;
										}
										 else 
										{
											if ((  ! (param.ContainsGenericParameters)  &&  ! (param.IsAssignableFrom(ts[i2]))  )) 
											{
												fits = false;
												break;
											}
											
										}
										
									}
									
								}
								
								if (fits) 
								{
									methods[last++] = methods[i1];
								}
								
							}
							
						}
						
					}
					
					methodLength = last;
				}
				 else 
				{
					if (( ( methodLength == 1 ) && ( methods[0].GetParameters().Length != length ) )) 
					{
						methodLength = 0;
					}
					
				}
				
				if (( methodLength == 0 )) 
				{
					throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.concat("Invalid calling parameters for method ", methods[0].Name));
				}
				
				global::System.Reflection.ParameterInfo[] params1 = methods[0].GetParameters();
				{
					int _g12 = 0;
					int _g3 = params1.Length;
					while (( _g12 < _g3 ))
					{
						int i3 = _g12++;
						global::System.Type param1 = params1[i3].ParameterType;
						string strParam1 = global::haxe.lang.Runtime.concat(global::Std.@string(param1), "");
						if (strParam1.StartsWith("haxe.lang.Null")) 
						{
							oargs[i3] = global::haxe.lang.Runtime.mkNullable(oargs[i3], param1);
						}
						 else 
						{
							if ((((global::System.Type) (typeof(global::System.IConvertible)) )).IsAssignableFrom(param1)) 
							{
								if (( oargs[i3] == default(object) )) 
								{
									if (param1.IsValueType) 
									{
										oargs[i3] = global::System.Activator.CreateInstance(param1);
									}
									
								}
								 else 
								{
									oargs[i3] = (((global::System.IConvertible) (oargs[i3]) )).ToType(param1, default(global::System.IFormatProvider));
								}
								
							}
							
						}
						
					}
					
				}
				
				if (( methods[0].ContainsGenericParameters && ( methods[0] is global::System.Reflection.MethodInfo ) )) 
				{
					global::System.Reflection.MethodInfo m = ((global::System.Reflection.MethodInfo) (methods[0]) );
					global::System.Type[] tgs = m.GetGenericArguments();
					{
						int _g13 = 0;
						int _g4 = tgs.Length;
						while (( _g13 < _g4 ))
						{
							int i4 = _g13++;
							tgs[i4] = typeof(object);
						}
						
					}
					
					m = m.MakeGenericMethod(tgs);
					object retg = m.Invoke(obj, oargs);
					return global::haxe.lang.Runtime.unbox(retg);
				}
				
				global::System.Reflection.MethodBase m1 = methods[0];
				if (( ( obj == default(object) ) && ( m1 is global::System.Reflection.ConstructorInfo ) )) 
				{
					object ret = (((global::System.Reflection.ConstructorInfo) (m1) )).Invoke(oargs);
					return global::haxe.lang.Runtime.unbox(ret);
				}
				
				object ret1 = m1.Invoke(obj, oargs);
				return global::haxe.lang.Runtime.unbox(ret1);
			}
		}
		
		
		public static   object unbox(object dyn)
		{
			unchecked 
			{
				if (( ( ! (( dyn == default(object) )) ) && (global::haxe.lang.Runtime.concat(global::Std.@string(global::cs.Lib.nativeType(dyn)), "")).StartsWith("haxe.lang.Null") )) 
				{
					return ((object) (global::haxe.lang.Runtime.callField(dyn, "toDynamic", 1705629508, default(global::Array))) );
				}
				 else 
				{
					return dyn;
				}
				
			}
		}
		
		
		public static   object mkNullable(object obj, global::System.Type nullableType)
		{
			
		if (nullableType.ContainsGenericParameters)
			return haxe.lang.Null<object>.ofDynamic<object>(obj);
		return nullableType.GetMethod("_ofDynamic").Invoke(null, new object[] { obj });
	
		}
		
		
		public static   object slowCallField(object obj, string field, global::Array args)
		{
			
		if (args == null) args = new Array<object>();

		System.Reflection.BindingFlags bf;
		System.Type t = obj as System.Type;
		if (t == null)
		{
			string s = obj as string;
			if (s != null)
				return haxe.lang.StringRefl.handleCallField(s, field, args);
			t = obj.GetType();
			bf = System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.FlattenHierarchy;
		} else {
			if (t == typeof(string) && field.Equals("fromCharCode"))
				return haxe.lang.StringExt.fromCharCode(toInt(args[0]));
			obj = null;
			bf = System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public;
		}

		System.Reflection.MethodInfo[] mis = t.GetMethods(bf);
		int last = 0;
		for (int i = 0; i < mis.Length; i++)
		{
			if (mis[i].Name.Equals(field))
			{
				mis[last++] = mis[i];
			}
		}

		if (last == 0)
		{
			throw haxe.lang.HaxeException.wrap("Method '" + field + "' not found on type " + t);
		}

		return haxe.lang.Runtime.callMethod(obj, mis, last, args);
	
		}
		
		
		public static   object callField(object obj, string field, int fieldHash, global::Array args)
		{
			
		haxe.lang.HxObject hxObj = obj as haxe.lang.HxObject;
		if (hxObj != null)
			return hxObj.__hx_invokeField(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, args);

		return slowCallField(obj, field, args);
	
		}
		
		
		public static   object getField(object obj, string field, int fieldHash, bool throwErrors)
		{
			

		haxe.lang.HxObject hxObj = obj as haxe.lang.HxObject;
		if (hxObj != null)
			return hxObj.__hx_getField(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, throwErrors, false, false);

		return slowGetField(obj, field, throwErrors);

	
		}
		
		
		public static   double getField_f(object obj, string field, int fieldHash, bool throwErrors)
		{
			

		haxe.lang.HxObject hxObj = obj as haxe.lang.HxObject;
		if (hxObj != null)
			return hxObj.__hx_getField_f(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, throwErrors, false);

		return (double)slowGetField(obj, field, throwErrors);

	
		}
		
		
		public static   object setField(object obj, string field, int fieldHash, object @value)
		{
			

		haxe.lang.HxObject hxObj = obj as haxe.lang.HxObject;
		if (hxObj != null)
			return hxObj.__hx_setField(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, value, false);

		return slowSetField(obj, field, value);

	
		}
		
		
		public static   double setField_f(object obj, string field, int fieldHash, double @value)
		{
			

		haxe.lang.HxObject hxObj = obj as haxe.lang.HxObject;
		if (hxObj != null)
			return hxObj.__hx_setField_f(field, (fieldHash == 0) ? haxe.lang.FieldLookup.hash(field) : fieldHash, value, false);

		return (double)slowSetField(obj, field, value);

	
		}
		
		
		public static   string toString(object obj)
		{
			unchecked 
			{
				if (( obj == default(object) )) 
				{
					return default(string);
				}
				
				if (( obj is bool )) 
				{
					if (((bool) ((obj)) )) 
					{
						return "true";
					}
					 else 
					{
						return "false";
					}
					
				}
				
				return obj.ToString();
			}
		}
		
		
		public static   bool typeEq(global::System.Type t1, global::System.Type t2)
		{
			
			if (t1 == null || t2 == null)
				return t1 == t2;
			string n1 = Type.getClassName(t1);
			string n2 = Type.getClassName(t2);
			return n1.Equals(n2);
	
		}
		
		
		public static   To genericCast<To>(object obj)
		{
			
		if (obj is To)
			return (To) obj;
		else if (obj == null)
			return default(To);
		if (typeof(To) == typeof(double))
			return (To)(object) toDouble(obj);
		else if (typeof(To) == typeof(int))
			return (To)(object) toInt(obj);
		else
			return (To) obj;
	
		}
		
		
		public static   string concat(string s1, string s2)
		{
			
		return (s1 == null ? "null" : s1) + (s2 == null ? "null" : s2);
	
		}
		
		
	}
}



namespace haxe.lang
{
	public enum EmptyObject
	{
		EMPTY
	}
}


