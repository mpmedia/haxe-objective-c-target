#ifndef INCLUDED_List
#define INCLUDED_List

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(List)


class List_obj extends public hx::Object{
	public:
		typedef hx::Object super;
		typedef List_obj OBJ_;
		List_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< List_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~List_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("List"); }

		virtual ::List map( Dynamic f);
		Dynamic map_dyn();

		virtual ::List filter( Dynamic f);
		Dynamic filter_dyn();

		virtual ::String join( ::String sep);
		Dynamic join_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual Dynamic iterator( );
		Dynamic iterator_dyn();

		virtual bool remove( Dynamic v);
		Dynamic remove_dyn();

		virtual Void clear( );
		Dynamic clear_dyn();

		virtual bool isEmpty( );
		Dynamic isEmpty_dyn();

		virtual Dynamic pop( );
		Dynamic pop_dyn();

		virtual Dynamic last( );
		Dynamic last_dyn();

		virtual Dynamic first( );
		Dynamic first_dyn();

		virtual Void push( Dynamic item);
		Dynamic push_dyn();

		virtual Void add( Dynamic item);
		Dynamic add_dyn();

		int length;
		Dynamic q;
		Dynamic h;
};


#endif /* INCLUDED_List */ 