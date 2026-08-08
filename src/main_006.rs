/*
 * I am dedicated to my path. I am learning to become a Rust and Zig developer,
 * on small step at a time. I hold onto my dream not as a guarantee of success,
 * but as a commitment to keep trying every single day.
 */

//! Using time crate

// static global variable
static MY_MESSAGE: &'static str = "A new Topic, a new victory ...";

use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
    println!("\n");

    static MY_NAME: &'static str = "Raphael";

    println!(" -> value of my name is: {}", MY_MESSAGE);
    println!(
        " -> again my name is: {}",
        friedrich_nietzsche::get_message()
    );

    end_message("0.1.0");
    Ok(())
}

fn end_message(version: &str) {
    println!("\n 私の夢, トヨタのプログラマーになりたいです。");
    println!(" この目標を達成するまで、毎日昨日よりも良いコードを書きます。");
    println!(" ラミン あなたは本当に素晴らしい。また会いましょう。{version}\n");
}

mod friedrich_nietzsche {
    use crate::MY_MESSAGE;

    pub const fn get_message() -> &'static str {
        MY_MESSAGE
    }

    /* encounter with compile time error. */
    // pub const fn get_my_name() -> &'static str {
    //     MY_NAME // variable not found in this scope
    // }
}

/* encounter with compile time error. */
// pub const fn get_my_name() -> &'static str {
//     MY_NAME // variable not found in this scope
// }
