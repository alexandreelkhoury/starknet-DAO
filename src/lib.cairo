mod components {
    mod dao_component;
    mod erc20_component;
}


mod interfaces {
    mod dao;
    mod erc20;
    mod erc20dao;
}

mod core {
    mod dao;
    mod erc20;
    mod dao_erc20;
}

#[cfg(test)]
mod tests {
    mod test;
}