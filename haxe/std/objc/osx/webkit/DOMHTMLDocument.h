/*
 * Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009 Apple Inc. All rights reserved.
 * Copyright (C) 2006 Samuel Weinig <sam.weinig@gmail.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE COMPUTER, INC. ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE COMPUTER, INC. OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 */

#import <WebKit/DOMDocument.h>

#if WEBKIT_VERSION_MAX_ALLOWED >= WEBKIT_VERSION_1_3

@class DOMElement;
@class DOMHTMLCollection;
@class NSString;

extern class DOMHTMLDocument : DOMDocument
	public var (default, null) DOMHTMLCollection *embeds AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var (default, null) DOMHTMLCollection *plugins AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var (default, null) DOMHTMLCollection *scripts AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var  (default, null) : int width AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var  (default, null) : int height AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var NSString *dir AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var NSString *designMode AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var (default, null) NSString *compatMode AVAILABLE_IN_WEBKIT_VERSION_4_0;
	public var (default, null) DOMElement *activeElement AVAILABLE_IN_WEBKIT_VERSION_4_0;
	public var NSString *bgColor AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var NSString *fgColor AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var NSString *alinkColor AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var NSString *linkColor AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
	public var NSString *vlinkColor AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;

- (void)open;
- (void)close;
- (void)write:(NSString *)text;
- (void)writeln:(NSString *)text;
- (void)clear AVAILABLE_IN_WEBKIT_VERSION_4_0;
- (void)captureEvents AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
- (void)releaseEvents AVAILABLE_WEBKIT_VERSION_3_0_AND_LATER;
- (BOOL)hasFocus AVAILABLE_IN_WEBKIT_VERSION_4_0;
}

#endif
