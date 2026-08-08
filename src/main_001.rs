/*
 * I am dedicated to my path. I am learning to become a Rust and Zig developer,
 * one small step at a time. I hold onto my dream not as a guarantee of success,
 * but as a commitment to keep trying every single day.
 */

//! Using time crate

use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
    println!("\n");

    end_message("0.1.0");
    Ok(())
}

fn end_message(version: &str) {
    println!("\n 私の夢, トヨタのプログラマーになりたいです。");
    println!(" この目標を達成するまで、毎日昨日よりも良いコードを書きます。");
    println!(" ラミン あなたは本当に素晴らしい。また会いましょう。{version}\n");
}

pub mod resource_one {
    pub const R_ONE: &str = "I am r one";
    pub const R_TWO: &str = "I am r two";
}

pub mod resource_two {
    pub const NUM_ONE: i32 = 1;
    pub const NUM_TWO: i32 = 2;
}

pub mod resource_three {

    struct FriedrichNietzsche<'a> {
        field_one: &'a str,
        field_two: u64,
    }

    pub const MY_FRIEDRICH_NIETZSCHE: FriedrichNietzsche = FriedrichNietzsche {
        field_one: "field one",
        field_two: 1200_u64,
    };
}
