use std::process::Command;

#[derive(Debug)]
struct Link<'a> {
    source: &'a str,
    destination: &'a str,
}

impl<'a> Link<'a> {
    fn new(source: &'a str, destination: &'a str) -> Self {
        Self {
            source,
            destination,
        }
    }

    fn do_link(&self) -> Option<()> {
        // TODO(patrik): Check if the source exists
        let output = Command::new("ln")
                        .arg("-s")
                        .arg(self.source)
                        .arg(self.destination)
                        .output()
                        .ok()?;

        println!("Output: {}", String::from_utf8_lossy(&output.stdout));
        println!("Error: {}", String::from_utf8_lossy(&output.stderr));
        println!("Status: {}", output.status);

        Some(())
    }
}

fn main() {
    let link = Link::new("wooh", "test2");
    link.do_link().unwrap();

    let meta = std::fs::symlink_metadata("./target").unwrap();
    println!("Meta: {:?}", meta);
}
