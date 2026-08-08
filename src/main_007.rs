/*
 * I am dedicated to my path. I am learning to become a Rust and Zig developer,
 * on small step at a time. I hold onto my dream not as a guarantee of success,
 * but as a commitment to keep trying every single day.
 */

//! Using time crate

use std::error::Error;
const BUFFER_SIZE: usize = 4096;
const PI: f64 = std::f64::consts::PI;

fn main() -> Result<(), Box<dyn Error>> {
    println!("\n");

    let my_array = [0_u8; BUFFER_SIZE];

    println!(" -> value of PI: {}", PI);
    println!(" -> my_array length: {}", my_array.len());

    end_message("0.1.0");
    Ok(())
}

fn end_message(version: &str) {
    println!("\n 私の夢, トヨタのプログラマーになりたいです。");
    println!(" この目標を達成するまで、毎日昨日よりも良いコードを書きます。");
    println!(" ラミン あなたは本当に素晴らしい。また会いましょう。{version}\n");
}
