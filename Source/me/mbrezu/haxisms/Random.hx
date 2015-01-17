/****
* Copyright (c) 2013 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

// Miron Brezuleanu: Moved to a package since the original lib was using the default package.
// Miron Brezuleanu: Added a seedable random number generator (xorshift).

package me.mbrezu.haxisms;

class SeedableRng {
    private var x: Int;
    private var y: Int;
    private var z: Int;
    private var w: Int;

    public function new(seed: Int) {
        x = seed;
        y = seed ^ 1123456789;
        z = seed ^ 1362436069;
        w = seed ^ 2121288629;
        for (i in 0...100) {
            nextInt();
        }
    }
    
    public function nextInt() {
        var t = x ^ (x << 11);
        x = y; y = z; z = w;
        return w = w ^ (w >> 19) ^ (t ^ (t >> 8));
    }
    
    public function nextFloat() { 
        return (nextInt() & 0xfffffff) * 1.0 / 0xfffffff;
    }
}

class Random
{   
    private var rng: SeedableRng;
    
    public function new(seed: Int = 10101) {
        rng = new SeedableRng(seed);
    }
    
	/** Return a random boolean value (true or false) */
	public inline function bool():Bool
	{
		return rng.nextFloat() < 0.5;
	}

	/** Return a random integer between 'from' and 'to', inclusive. */
	public inline function int(from:Int, to:Int):Int
	{
		return from + Math.floor(((to - from + 1) * rng.nextFloat()));
	}

	/** Return a random float between 'from' and 'to', inclusive. */
	public inline function float(from:Float, to:Float):Float
	{
		return from + ((to - from) * rng.nextFloat());
	}

	/** Return a random string of a certain length.  You can optionally specify 
	    which characters to use, otherwise the default is (a-zA-Z0-9) */
	public function string(length:Int, ?charactersToUse = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String
	{
		var str = "";
		for (i in 0...length)
		{
			str += charactersToUse.charAt(int(0, charactersToUse.length - 1));
		}
		return str;
	}

	/** Return a random date & time from within a range.  The behaviour is unspecified if either `earliest` or `latest` is null.  Earliest and Latest are inclusive */
	public inline function date(earliest:Date, latest:Date):Date
	{
		return Date.fromTime( float(earliest.getTime(), latest.getTime()) );
	}

	/** Return a random item from an array.  Will return null if the array is null or empty. */
	public inline function fromArray<T>(arr:Array<T>):Null<T>
	{
		return (arr != null && arr.length > 0) ? arr[int(0, arr.length - 1)] : null;
	}

	/** Shuffle an Array.  This operation affects the array in place, and returns that array.
		The shuffle algorithm used is a variation of the [Fisher Yates Shuffle](http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle) */
	public function shuffle<T>(arr:Array<T>):Array<T>
	{
		if (arr!=null) {
			for (i in 0...arr.length) {
				var j = int(0, arr.length - 1);
				var a = arr[i];
				var b = arr[j];
				arr[i] = b;
				arr[j] = a;
			}
		}
		return arr;
	}

	/** Return a random item from an iterable.  Will return null if the iterable is null or empty. */
	public inline function fromIterable<T>(it:Iterable<T>):Null<T>
	{
		return (it != null) ? fromArray(Lambda.array(it)) : null;
	}

	/** Return a random constructor from an Enum.  Will return null if the enum has no constructors. Only works with enum constructors that take no parameters. */
	public inline function enumConstructor<T>(e:Enum<T>):Null<T>
	{
		return (e!=null) ? fromArray(Type.allEnums(e)) : null;
	}
}